{CompositeDisposable} = require 'atom'

module.exports =
  config:
    dscannerPath:
      type: 'string'
      default: '';
      title: 'Dscanner Executable Path'

  defaultDscanner: ''

  activate: ->
    @defaultDscanner = atom.packages.loadedPackages['linter-dscanner'].path + "/bin/dscanner-" + process.platform;
    console.log("default dscanner path:", @defaultDscanner)

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'linter-dscanner.dscannerPath',
      (dscannerPath) => @dscannerPath = if dscannerPath == '' then @defaultDscanner else dscannerPath

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
        return helpers.exec(@dscannerPath, ['--styleCheck', filePath], {stream: 'stdout'})
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
