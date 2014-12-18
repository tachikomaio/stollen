cron = require('cron').CronJob
LogentriesRetrievingLog = require('logentries-retrieving-log')
accountKey = process.env.HUBOT_LOGENTRIES_STOLLEN_KEY
logAddr = process.env.HUBOT_LOGENTRIES_STOLLEN_KEY_ADDR

retriever = LogentriesRetrievingLog({
  accountKey: accountKey,
  logAddr: logAddr
})
room = process.env.HUBOT_LOGENTRIES_STOLLEN_ROOM
params = {start: - 60 * 1000}

module.exports = (robot) ->
  new cron '10 * * * * *', () =>
    if !accountKey || !logAddr || !room
      robot.logger.error "env missing" + \
        "HUBOT_LOGENTRIES_STOLLEN_KEY: #{process.env.HUBOT_LOGENTRIES_STOLLEN_KEY}" + \
        "HUBOT_LOGENTRIES_STOLLEN_KEY_ADDR: #{process.env.HUBOT_LOGENTRIES_STOLLEN_KEY_ADDR}" + \
        "HUBOT_LOGENTRIES_STOLLEN_ROOM: #{process.env.HUBOT_LOGENTRIES_STOLLEN_ROOM}"
      return
    retriever.getLogs params, (err, _, body) =>
      if (err)
        robot.logger.error "logentries error: #{err}, body: #{body}"
        return
      robot.send {room: room}, body, null, true, "Asia/Tokyo"
