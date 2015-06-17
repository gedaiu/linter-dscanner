# linter-dscanner package

This linter plugin for [Linter](https://github.com/AtomLinter/Linter) provides an interface to [dscanner](https://github.com/Hackerpilot/Dscanner). It will be used for D files.

## Installation
Linter package must be installed in order to use this plugin. If Linter is not installed, please follow the instructions [here](https://github.com/AtomLinter/Linter).

And you should already have the [dscanner](https://github.com/Hackerpilot/Dscanner) installed

### Plugin installation
```
$ apm install linter-dscanner
```

## Settings
You can configure linter-php by editing ~/.atom/config.cson (choose Open Your Config in Atom menu):
```
'linter-dscanner':
  'dscannerExecutablePath': null # dscanner path
```
