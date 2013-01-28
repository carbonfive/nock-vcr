nvcr = require '../../src/nock-vcr'

util = require 'util'
fs = require 'fs'
http = require 'http'

after ->
  try
    fs.unlinkSync 'test/cassettes/my-awesome-cassette.js'
    fs.rmdirSync 'test/cassettes'
  catch error
    console.error error

describe 'nvcr', ->
  requestGoogle = (onComplete)=>
    options = method: 'GET', host: 'google.com', port: 80, path: '/'
    http.request(options, (res)=>
      res.on 'end', =>
        nvcr.ejectCassette()
        onComplete()
    ).end()

  describe 'recording', ->
    context 'when inserting non-existant cassette', ->
      beforeEach (done)->
        nvcr.insertCassette 'My Awesome Cassette'
        requestGoogle done

      it 'creates a cassette', ->
        expect(fs.existsSync('test/cassettes/my-awesome-cassette.js')).to.be.true

      context 'and when running the same request again', ->
        beforeEach (done)->
          @beforeRunCassetteStats = fs.statSync 'test/cassettes/my-awesome-cassette.js'
          setTimeout((=>
            nvcr.insertCassette 'My Awesome Cassette'
            requestGoogle =>
              @afterRunCassetteStats = fs.statSync 'test/cassettes/my-awesome-cassette.js'
              done()
          ), 1000)

        it 'does not overwrite the cassette', ->
          expect(@afterRunCassetteStats.mtime.getTime()).to.equal(@beforeRunCassetteStats.mtime.getTime())

        context 'when inserting a cassette multiple times', ->
          beforeEach (done)->
            @beforeRunCassetteStats = fs.statSync 'test/cassettes/my-awesome-cassette.js'
            setTimeout((=>
              nvcr.insertCassette 'My Awesome Cassette'
              requestGoogle =>
                @afterRunCassetteStats = fs.statSync 'test/cassettes/my-awesome-cassette.js'
                done()
            ), 1000)

          it 'does not overwrite the cassette', ->
            expect(@afterRunCassetteStats.mtime.getTime()).to.equal(@beforeRunCassetteStats.mtime.getTime())

      context 'when inserting an existing cassette with recording on', ->
        beforeEach (done)->
          @beforeRunCassetteStats = fs.statSync 'test/cassettes/my-awesome-cassette.js'
          setTimeout((=>
            nvcr.insertCassette 'My Awesome Cassette', record: 'ALL'
            requestGoogle =>
              @afterRunCassetteStats = fs.statSync 'test/cassettes/my-awesome-cassette.js'
              done()
          ), 1000)

        it 'overwrites the the cassette', ->
          expect(@afterRunCassetteStats.mtime.getTime()).to.be.greaterThan(@beforeRunCassetteStats.mtime.getTime())
