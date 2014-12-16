# Description
#   A hubot script that notify to every time a new error occurs in Logentries
#
# Dependencies:
#   None
#
# Configuration:
#
# Commands:
#   None
#
# URLS:
#   POST /<hubot>/logentries/<room>
#
# Notes:
#  https://logentries.com/doc/webhookalert/
#
# Author:
#   sanemat

class Base
  constructor: (@req, @robot) ->
    @json  = @req.body

  room: ->
    @req.params.room || ""

  alert: ->
    @json.alert

  host: ->
    @json.host

  log: ->
    @json.log

  event: ->
    @json.event

  context: ->
    @json.context

  notice: ->
    "#{@log().name}|#{@alert().name}|#{@event().t}|#{@event().s}|#{@event().m}"

  notify: ->
    @robot.send {room: @room()}, @notice()


module.exports = (robot) ->
  robot.router.post "/#{robot.name}/logentries/:room", (req, res) ->
    try
      postman = new Base(req, robot)
      postman.notify()
      res.end "[Logentries] Sending message"
    catch e
      res.end "[Logentries] #{e}"
