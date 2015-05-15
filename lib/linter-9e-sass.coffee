linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
{findFile, warn} = require "#{linterPath}/lib/utils"
fs = require 'fs'
path = require 'path'

module.exports = class Linter9eSass extends Linter

  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.sass']

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: ['cmd']

  linterName: '9e-sass'

  errorStream: 'stdout'

  # A regex pattern used to extract information from the executable's output.
  regex:
    '^(?<file>.*?\\..*?(?=:))' +
    ':(?<line>[0-9]+):(?<col>[0-9]+):' +
    '(?<message>.*?)$'

  regexFlags: 'gm'

  isNodeExecutable: yes

  constructor: (editor) ->
    super(editor)
    @cwd = null

    @formatShellCmd()

  formatShellCmd: () =>
    @executablePath = path.join __dirname,
      '..',
      'node_modules',
      '.bin',
      '9e-sass-lint'

    if !fs.existsSync @executablePath
      throw new Error '9e-sass-lint wasn\'t
        installed properly with linter-9e-sass,
        please re-install the plugin.'

  formatMessage: (match) ->
    if !match.error && !match.warning
      warn "Regex does not match lint output", match

    ## Dunno why I need to do this
    ## but if I dont it doesnt show a message
    "#{match.message}"
