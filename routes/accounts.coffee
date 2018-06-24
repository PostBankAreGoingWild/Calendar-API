crypto = require 'crypto'
validator = require 'validator'

modules = 
    db: require '../modules/db'
    user: require '../modules/user'
    
models = 
    user: require '../models/user'
    session: require '../models/session'

randomString = (length, chars) ->
    result = ''
    i = length
    while i > 0
        result += chars[Math.floor Math.random() * chars.length]
        --i
    result

checkSessionId = (sessionId) ->
    asd = true
    modules.db.find models.session.type, { id: sessionId }, (err, sessions) ->
        if sessions.length > 0
            asd = false
        return
    asd

postLogin = (req, res) ->
    user = modules.db.find models.user.type, { email: req.body.email }, (err, usr) ->
        if !usr.length
            res.status 400
            res.send 'Грешен имейл или парола'
        else
            if usr[0].password == crypto.createHmac('sha256', usr[0].passwordsha256).update(req.body.password).digest 'hex'
                sessionId = ''
                loop
                    sessionId = randomString 64, '`1234567890-=qwetyuiop[]asdfghjkl;\'\\zxcvbnm,./~!@#$%^&*()_+QWERTYUIOP{}ASDFGHJKL:"|ZXCVBNM<>?åöäÅÖÄßüÜявертъуиопшщасдфгхйклюзьцжбнмЧ№€§=-½¤=ЯВЕРТЪУИОПШЩАСДФГХЙКЛЗѝЦЖБНМ“;ςερτυθιοπλκξηγφδσαζχψωβνμ3ΕΡΤΥΘΙΟΠΑΣΔΦΓΗΞΚΛΖΧΨΩΒΝΜ'
                    if checkSessionId(sessionId)
                        break
                if req.body.rememberme
                    res.cookie 'sessionId', sessionId, expires: new Date(253402300000000)
                else
                    res.cookie 'sessionId', sessionId
                modules.db.add new (models.session.type)(
                    id: sessionId
                    username: usr[0].email), (a) ->
                res.send()
            else
                res.status 400
                res.send 'Грешен имейл или парола'
        return
    return

postRegister = (req, res) ->
    modules.db.find models.user.type, {username: req.body.email}, (err, usr) ->
        if usr.length
            res.status 400
            res.send 'Този имейл е вече регистриран'
        else 
            if validator.isEmail req.body.email
                if req.body.password.length > 6 && req.body.password.length < 100
                    if req.body.password == req.body.password2
                        date = (new Date).toString()
                        date = crypto.createHmac('sha256', 'Тех вилд').update(date).digest 'hex'
                        modules.db.add new (models.user.type)(
                            passwordsha256: date
                            password: crypto.createHmac('sha256', date).update(req.body.password).digest 'hex'
                            email: req.body.email), (a) ->
                            res.send()
                            return
                    else
                        res.status 400
                        res.send "Въведените пароли не съвпадат"
                else
                    res.status 400
                    res.send "Паролата трябва да е между 6 и 100 символа"
            else
                res.status 400
                res.send "Невалиден имейл"
        return
    return 


logout = (req, res) ->
    res.cookie 'sessionId', undefined
    modules.db.remove models.session.type, { id: req.cookies.sessionId }, (err) ->
    res.send()
    return    

getLogedUserEmail = (req, res) ->
    modules.user.getUsername req.cookies.sessionId, (name) ->
        res.send name

exports.getLogedUserEmail = getLogedUserEmail
exports.postLogin = postLogin
exports.postRegister = postRegister
exports.logout = logout