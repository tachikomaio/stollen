cron = require('cron').CronJob
LogentriesRetrievingLog = require('logentries-retrieving-log')
accountKey = process.env.HUBOT_LOGENTRIES_STOLLEN_KEY
logAddr = process.env.HUBOT_LOGENTRIES_STOLLEN_ADDR

retriever = new LogentriesRetrievingLog({
  accountKey: accountKey,
  logAddr: logAddr
})
room = process.env.HUBOT_LOGENTRIES_STOLLEN_ROOM
# logentries delays 10-30sec, so get from 2minutes ago to 1minute ago
params = {start: - 2 * 60 * 1000, end: - 1 * 60 * 1000}

module.exports = (robot) ->
  new cron '10 * * * * *', () ->
    if !accountKey || !logAddr || !room
      robot.logger.error "env missing " + \
        "HUBOT_LOGENTRIES_STOLLEN_KEY: #{process.env.HUBOT_LOGENTRIES_STOLLEN_KEY} " + \
        "HUBOT_LOGENTRIES_STOLLEN_ADDR: #{process.env.HUBOT_LOGENTRIES_STOLLEN_ADDR} " + \
        "HUBOT_LOGENTRIES_STOLLEN_ROOM: #{process.env.HUBOT_LOGENTRIES_STOLLEN_ROOM}"
      return
    retriever.getLogs params, (err, _, body) ->
      if (err)
        robot.logger.error "logentries error: #{err}, body: #{body}"
        return
      robot.send {room: room}, body
  , null, true, "Asia/Tokyo"
