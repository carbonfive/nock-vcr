{ print } = require 'util'
{ spawn, exec } = require 'child_process'
fs = require 'fs'

build = (watch, callback)->
  if typeof watch is 'function'
    callback = watch
    watch = false

  options = ['-c', '-o', 'lib', 'src']
  options.unshift '-w' if watch

  coffee = spawn './node_modules/.bin/coffee', options
  coffee.stdout.on 'data', (data) -> print data.toString()
  coffee.stderr.pipe process.stderr
  coffee.on 'exit', (status) -> callback?() if status is 0

task 'build', 'Compile Coffeescript source files', ->
  build()

task 'watch', 'Recompile Coffeescript source when modified', ->
  build true

task 'test', 'Run the test suite', ->
  mocha = spawn './node_modules/mocha/bin/mocha', ['test/lib']
  mocha.stderr.pipe process.stderr
  mocha.stdout.pipe process.stdout
  mocha.on 'exit', (status)-> process.exit(status)
