require("coffee-script")
try
	require('source-map-support').install()

require("colors")

Program = require("commander")
Downloader = require("./lib/downloader")

getBaseDir = -> "download"

Program
	.version("0.0.1")

	.option("-u, --username [username]", "Spotify Username (required)", null)
	.option("-p, --password [password]", "Spotify Password (required)", null)

	.option("-i, --uri [url / uri]", "Spotify URL / URI (Track / Album / Playlist)", null)

	.option("-d, --directory [directory]", "Download Directory - Default: \"downloads\" folder within the same directory", getBaseDir())
	.option("-h  --format [format]", "Format file paths - Ex: \"{artist.name}/{album.name}/{track.name}.mp3\"")
	.option("-f, --folder", "Save songs in single folder with the playlist name (PLAYLISTS ONLY!)")
	#.option("-g, --generate", "Generate file for playlist (PLAYLISTS ONLY!)")

	.parse(process.argv)

config =
	username: Program.username
	password: Program.password

	uri: Program.uri

	directory: Program.directory
	format: Program.format
	folder: Program.folder
	generate: Program.generate

	onWindows: process.platform == 'win32'

if !config.username? or !config.password?
	console.log "No username / password specified!".red
	return Program.outputHelp()

if !config.uri?
	console.log "No URI specified!".red
	return Program.outputHelp()

# Check if it's a Spotify Web-URL - if it is, convert it to a URI
config.uri = config.uri.replace(/^(https?):\/\//, "")
config.uri = config.uri.replace("play.spotify.com", "spotify").replace(/\//g, ":")

if config.uri.indexOf("album") != -1
	config.type = "album"
else if config.uri.indexOf("track") != -1
	config.type = "track"
else if config.uri.indexOf("playlist") != -1
	config.type = "playlist"
else if config.uri == "library"
	config.type = "library"
else
	console.log "Invalid URI specified!".red
	return Program.outputHelp()

downloader = new Downloader config

downloader.run()
