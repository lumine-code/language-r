describe("language-r editing defaults", () => {
  let editor;
  beforeEach(async () => {
    jasmine.useRealClock();
    await lumine.packages.activatePackage("language-source");
    await lumine.packages.activatePackage("language-r");

    editor = await lumine.workspace.open();
    editor.setGrammar(lumine.grammars.grammarForScopeName("source.r"));
    editor.setText("data.frame(value = 1)");
    await editor.whenGrammarSettled();
  });
  afterEach(() => editor?.destroy());

  it("selects a complete language identifier without including adjacent syntax", () => {
    const index = editor.getText().indexOf("data.frame");
    editor.setCursorBufferPosition(editor.getBuffer().positionForCharacterIndex(index + 2));
    editor.selectWordsContainingCursors();
    expect(editor.getSelectedText()).toBe("data.frame");
  });
  it("keeps explicit user word-boundary overrides", () => {
    const options = { scopeSelector: ".source.r" };
    try {
      lumine.config.set("editor.nonWordCharacters", ".", options);
      const index = editor.getText().indexOf("data.frame");
      editor.setCursorBufferPosition(editor.getBuffer().positionForCharacterIndex(index + 2));
      editor.selectWordsContainingCursors();
      expect(editor.getSelectedText()).not.toBe("data.frame");
    } finally {
      lumine.config.unset("editor.nonWordCharacters", options);
    }
  });
});
