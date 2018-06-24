modules = 
    db: require '../modules/db'
    user: require '../modules/user'
    
models = 
    event: require '../models/event'

checkByDate = (event, userId, start, end) ->
    if !userId or event.userId == userId
        if start < event.start < end or start < event.end < end or (Math.floor ((start - event.start) / event.repeatingPeriod)) != (Math.floor ((end - event.end) / event.repeatingPeriod))
            return true
    false

getEventByDate = (req, res) ->
    modules.user.getUserID req.cookies.sessionId, (uID) ->
        modules.db.find models.event.type, {}, (err, events) ->
            if err
                res.status 500
                res.send()
            else
                resEvents = (event for event in events when (checkByDate event, uID, (new Date req.body.start), (new Date req.body.end)))
                res.json resEvents

postAddEvent = (req, res) ->
    modules.user.getUserID req.cookies.sessionId, (uID) ->
        modules.db.add new (models.event.type) (
                name: req.body.name
                start: new Date req.body.start
                end: new Date req.body.end
                repeatingPeriod: new Date req.body.rep
                descritption: req.body.desc
                type: req.body.type
                userId: uID
        )
    res.send()

exports.getEventByDate = getEventByDate
exports.postAddEvent = postAddEvent