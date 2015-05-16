path = require 'path'
Linter = require '9e-sass-lint/lib/linter'
File = require '9e-sass-lint/lib/file'
Fixer = require '9e-sass-lint/lib/fixer'

module.exports =
  disposables: []

  activate: (state) ->
    disposable = atom.commands.add 'atom-workspace', 'linter-9e-sass:format', => @formatCode()
    @disposables.push disposable

  deactivate: ->
    for disposable in @disposables
      disposable.dispose()
    @disposables = []

  formatCode: ->
    editor = atom.workspace.getActiveTextEditor()
    return unless editor

    buffer = editor.getBuffer()
    text = buffer.getText()

    linter = new Linter
    file = new File 'file', text
    linter.lintFile(file)
      .then (report) =>
        fixer = new Fixer linter
        fixer.fixReport(file, report)
      .then () =>
        buffer.setText file.content
