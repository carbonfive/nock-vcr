nvcr = require '../lib/nock-vcr'

fs = require 'fs'
http = require 'http'

requestComplete = false

describe 'using nock-vcr', ->
  context 'insert a cassette, and eject it when it is done', ->
    beforeEach (done)->
      nvcr.insertCassette 'Your cassette name here'
      options = method: 'GET', host: 'google.com', port: 80, path: '/'
      http.request(options, (res)=>
        res.on 'end', =>
          requestComplete = true
          nvcr.ejectCassette()
          done()
      ).end()

    it 'creates a cassette', ->
      expect(requestComplete).to.be.true
