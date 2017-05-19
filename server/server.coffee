bodyParser 	= require('body-parser');
exec 		= require('child_process').exec;
express 	= require('express');
app 		= express();

server 		= require('http').Server(app);
io 			= require('socket.io')(server);

require('colors')

Config = {
  DOMAIN: 		'localhost',
  PORT: 		3001,
  EXECUTABLE: 	'node main.js',
}

server.listen Config.PORT, Config.DOMAIN, () =>
  console.log "Server running at http://#{Config.DOMAIN}:#{Config.PORT}".green;

app.use('/assets', express.static(__dirname + '/assets'));
app.use bodyParser.json()
app.use bodyParser.urlencoded({extended: true})



root = (req, res) =>
  res.sendFile(__dirname + '/index.html');

app.get  '/'	, root


run = (req, response) =>
  if !sk
    console.error "Something went wrong. Socket is not started, try to refresh browser page or restart server".red
    return null;

  params = ""

  addParam = (optName, optValue) =>
    params += " #{optName} #{optValue}"	if !!optValue

  b = req.body
  
  addParam '--fbuid'	,	b.fbuid
  addParam '--fbtoken'	,	b.fbtoken
  
  addParam '--username'	,	b.username
  addParam '--password'	,	b.password
  addParam '--captcha'	,	b['g-recaptcha-response-1']?[0]
 
  addParam '--uri'		,	b.uri
  addParam '--directory',	b.directory

  format = b.format.trim()
  if !!b.folder
    addParam '--folder', if !!format then "\"#{ format }\"" else ""

  
  cmdline = "#{Config.EXECUTABLE} #{params}"
  
  console.log (cmdline)
  
  ls = exec(cmdline);

  ls.stdout.on 'data', (data) =>
#    console.log "#{data}".green
    sk.emit('progress', {progress: data});

  ls.stderr.on 'data', (data) =>
    if data.trim().length
      console.log "#{data}".red
    sk.emit('progress', {progress: data});
  #    response.send(JSON.stringify(data));

  ls.on 'exit', (data) =>
#    sk.emit('progress', {progress: data});
#    console.log('child process exited with code ' + data);
##    sk.emit('progress', {progress: data});
#    response.send(JSON.stringify(data));

app.post '/run'	, run

sk = null

io.set('origins', "*#{Config.DOMAIN}:#{Config.PORT}");

io.on 'connection', (socket) =>
  sk = socket