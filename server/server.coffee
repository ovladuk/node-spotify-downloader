bodyParser = require('body-parser');
exec = require('child_process').exec;
express = require('express');
app = express();
server = require('http').Server(app);
io = require('socket.io')(server);
require('colors')

Config = {
  PORT: 3001,
  EXECUTABLE: 'node',
}

server.listen Config.PORT, 'localhost', () =>
  console.log "Server running at http://localhost:#{Config.PORT}".green;

app.use('/assets', express.static(__dirname + '/assets'));
app.use bodyParser.json()
app.use bodyParser.urlencoded({extended: true})

root = (req, res) =>
  res.sendFile(__dirname + '/index.html');


run = (req, response) =>
  if !sk
    console.error "Something went wrong. Socket is not started, try to refresh browser page or restart server".red
    return null;

  params = ''
  params += if typeof req.body.username != 'undefined' then ' -u ' + req.body.username else ''
  params += if typeof req.body.password != 'undefined' then ' -p ' + req.body.password else ''
  params += if typeof req.body.uri != 'undefined' then ' -i ' + req.body.uri else ''
  params += if typeof req.body.directory != 'undefined' && req.body.directory != '' then ' -d ' + req.body.directory else ''

  if typeof req.body.folder != 'undefined' && typeof req.body.format.trim() != ''
    params += ' -f \"' + req.body.format.trim() + '\"'
  else
    params += if typeof req.body.folder != 'undefined' then ' -f ' else ''

  ls = exec("#{Config.EXECUTABLE} main.js #{params}");

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


app.get '/', root
app.post '/run', run

sk = null

io.set('origins', '*localhost:' + Config.PORT);
io.on 'connection', (socket) =>
  sk = socket