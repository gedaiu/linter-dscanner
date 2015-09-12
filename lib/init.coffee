{CompositeDisposable} = require 'atom'

module.exports =
  config:
    executablePath:
      type: 'string'
      default: ''
      title: 'Dscanner Executable Path'

  activate: ->
    console.log("activate linter-dscanner");
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'linter-dscanner.executablePath',
      (executablePath) =>
        @executablePath = executablePath
  deactivate: ->
    @subscriptions.dispose()
  provideLinter: () ->
    helpers = require('atom-linter')
    provider =
      grammarScopes: ['source.d']
      scope: 'file' # or 'project'
      lintOnFly: false # must be false for scope: 'project'
      lint: (textEditor) =>
        regex = '(.*)'+
               '\\((?<line>[0-9]*):(?<col>[0-9]*)\\)'+
               '\\[(?<errorType>[a-z]*)\\]: '+
               '(?<message>.*)'

        filePath = textEditor.getPath()
        console.log('lint ', filePath);
        return helpers.exec(@executablePath, ['--styleCheck', filePath], {stream: 'stdout'})
          .then (contents) ->
            list = helpers.parse(contents, regex)

            for item in list
              console.log(item);
              item.type = "warning"
              item.filePath = filePath
              item.range[0][1] = 0
              item.range[1][1] = 9999

            console.log(list)
            list
