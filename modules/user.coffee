modules = 
        db: require('../modules/db')
    
models = 
        session: require '../models/session'

getUsername = (sId, callback) ->
    console.log sId
    modules.db.find models.session.type, { id: sId }, (err, sessions) ->
        console.log sessions
        if sessions.length
            callback sessions[0].username
        else
            callback undefined
        return
    
exports.getUsername = getUsername