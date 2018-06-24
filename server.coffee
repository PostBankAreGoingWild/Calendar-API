http = require 'http'
express = require 'express'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'

routes = 
    accounts: require __dirname + '/routes/accounts' 
    events: require __dirname + '/routes/events'

modules = 
    user: require __dirname + '/modules/user'
    
app = express()

app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)

app.use cookieParser()

app.get '/', (req, res) ->
    res.redirect '/layout/index.html'

app.use express.static 'static'

app.post '/user/login', routes.accounts.postLogin

app.post '/user/register', routes.accounts.postRegister

app.get '/user/logout', routes.accounts.logout
app.post '/user/logout', routes.accounts.logout

app.get '/user/email', routes.accounts.getLogedUserEmail

app.get '/event', routes.events.getEventByDate
app.post '/event/add', routes.events.postAddEvent
app.post '/event/admin/add', routes.events.postAddEvent

app.use (req, res, next) ->
    res.status 404
    res.send()
    return

httpServer = http.createServer app 
httpServer.listen 3000
console.info 'Listening on *:3000'

#httpsServer = https.createServer(app)
#httpsServer.listen 5000