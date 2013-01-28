#Nock-VCR

Like the Ruby [VCR][VCR] gem, record your test-suite's HTTP interactions
and replay them during future runs for speedy, deterministic, and
accurate tests. Built atop [nock][nock]'s testing and recording
capability.

## Installation

```sh
npm install nock-vcr
```

## Usage

In your tests, require nock-vcr. Then use <code>insertCassette</code> to
mark the start of where recording - and later playback - should begin
and <code>ejectCassette</code> where it should end. Recorded "cassettes"
\- [nock][nock] code to mock the transactions - will be saved under
<code>test/cassettes</code>!

For example:

```coffeescript
nvcr = require 'nock-vcr'

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
```

You can force nock-vcr to record all the time by passing and setting a
<code>record</code> option of <code>insertCassette</code> to the string
<code>'ALL'</code>, or by setting the environment variable
<code>NOCK_VCR_MODE</code> to the same value.

## Notes

Currently this runs on top of [a modified version of nock][my-nock]
that corrects a bug in the code generated during recording as well as a
way to re-activate mocking after a restore.

## Upcoming Features

* More options that can affect the recording behavior.
* Hooks into popular testing frameworks.

  [my-nock]: http://github.com/rudyjahchan/nock
  [nock]: http://github.com/flatiron/nock
  [vcr]: http://github.com/vcr/vcr
