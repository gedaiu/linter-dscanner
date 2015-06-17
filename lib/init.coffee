module.exports =
  config:
    dscannerExecutablePath:
      type: 'string'
      default: ''
      title: 'Dscanner Executable Path'

  activate: ->
    console.log 'activate linter-dscanner'
