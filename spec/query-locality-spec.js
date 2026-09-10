const fs = require("fs");
const path = require("path");
const { Point } = require("lumine");

describe("R highlight query locality", () => {
  let editor;

  beforeEach(async () => {
    await lumine.packages.activatePackage("language-r");
    editor = await lumine.workspace.open("strings.r");
  });

  afterEach(() => editor?.destroy());

  async function setUp(text) {
    editor.setText(text);
    await editor.languageMode.ready;
    await editor.languageMode.atTransactionEnd();
  }

  function capturesForRows(startRow, endRow) {
    const layer = editor.languageMode.rootLanguageLayer;
    return layer.queries.highlightsQuery.captures(layer.tree.rootNode, {
      startPosition: new Point(startRow, 0),
      endPosition: new Point(endRow, 0),
    });
  }

  it("preserves escape and empty-string scopes with a leaf capture", async () => {
    await setUp('escaped <- "line\\nnext"\nempty <- ""');

    expect(editor.scopeDescriptorForBufferPosition([0, 16]).getScopesArray()).toContain(
      "constant.character.escape.r",
    );
    expect(editor.scopeDescriptorForBufferPosition([1, 10]).getScopesArray()).toContain(
      "string.quoted.double.r",
    );
  });

  it("keeps escapes local inside a 6000-row string", async () => {
    const lines = ['value <- "'];
    for (let index = 0; index < 6000; index++) lines.push(`  value_${index}\\n`);
    lines.push('"');
    await setUp(lines.join("\r\n"));

    expect(editor.languageMode.rootLanguageLayer.tree.rootNode.hasError).toBe(false);
    const captures = capturesForRows(3000, 3006);
    expect(captures.length).toBeLessThanOrEqual(32);
    const escapes = captures.filter((capture) => capture.name === "constant.character.escape.r");
    expect(escapes.length).toBe(6);
    expect(
      escapes.every(
        (capture) =>
          capture.node.startPosition.row >= 3000 && capture.node.startPosition.row < 3006,
      ),
    ).toBe(true);

    const query = fs.readFileSync(
      path.join(__dirname, "..", "grammars", "r-highlights.scm"),
      "utf8",
    );
    expect(query).toContain("(escape_sequence) @constant.character.escape.r");
    expect(query).not.toContain("(string (string_content (escape_sequence)");
  });
});
