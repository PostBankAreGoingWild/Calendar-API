modules = 
        db: require('../modules/db')
    
models = 
        session: require '../models/session'

getUsername = (sId, callback) ->
    modules.db.find models.session.type, { id: sId }, (err, sessions) ->
        if sessions.length
            callback sessions[0].username
        else
            callback undefined
        return

getUserID = (sId, callback) ->
    modules.db.find models.session.type, { id: sId }, (err, sessions) ->
        if sessions.length
            callback sessions[0].uId
        else
            callback undefined
        return

isAdmin = (sId, callback) ->
    modules.db.find models.session.type, { id: sId }, (err, sessions) ->
        if sessions.length
            callback sessions[0].isAdmin
        else
            callback undefined
        return
    
exports.getUsername = getUsername
exports.getUserID = getUserID
exports.isAdmin = isAdmin