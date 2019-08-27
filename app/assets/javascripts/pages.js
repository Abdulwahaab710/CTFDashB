var editor = ace.edit("editor");
var textarea = $('textarea[name="page[html_content]"]');
editor.setTheme('ace/theme/dracula')
editor.session.setMode("ace/mode/html");
editor.setAutoScrollEditorIntoView(true);
editor.setValue(textarea.val())

textarea.val(editor.getSession().getValue());
editor.getSession().on("change", function () {
  textarea.val(editor.getSession().getValue());
});
