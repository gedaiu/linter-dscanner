linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
{CompositeDisposable} = require 'atom'

class LinterDscanner extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: 'source.d'

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: 'dscanner --styleCheck'

  executablePath: null

  linterName: 'dscanner'

  # A regex pattern used to extract information from the executable's output.
  regex: '(.*)'+
         '\\((?<line>[0-9]*):(?<col>[0-9]*)\\)'+
         '\\[(?<errorType>[a-z]*)\\]: '+
         '(?<message>.*)'

  constructor: (editor) ->
    super(editor)
    @disposables = new CompositeDisposable

    @disposables.add atom.config.observe 'linter-dscanner.dscannerExecutablePath', =>
      @executablePath = atom.config.get 'linter-dscanner.dscannerExecutablePath'

  destroy: ->
    super
    @disposables.dispose()


  createMessage: (match) ->
    match.error = true if match.errorType == "error"
    match.warning = true if match.errorType == "warn"

    super match

module.exports = LinterDscanner
