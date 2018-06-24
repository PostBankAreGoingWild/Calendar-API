modules = 
    db: require '../modules/db'
    user: require '../modules/user'
    
models = 
    event: require '../models/event'

checkByDate = (event, date, userId) ->
    if !userId or event.userId == userId
        if Date event.start <= date <= Date event.end
            return true
    false

getEventByDate = (req, res) ->
    modules.db.find models.event.type, {}, (err, events) ->
        if err
            res.status 500
            res.send()
        else
            resEvents = (event for even in events when (checkByDate event, (Date req.date), modules.user.getUserID req.cookies.sessionId))
            res.json resEvents

exports.getEventByDate = getEventByDate