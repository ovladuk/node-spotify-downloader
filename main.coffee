require("coffee-script")
try
	require('source-map-support').install()

require("colors")

Program = require("commander")
Downloader = require("./lib/downloader")

getBaseDir = -> "download"

ARTISTS_TOKEN_DELIMITER = ","
ARTISTS_ID3_DELIMITER = "/"

Program
	.version("0.0.1")

	.option("-u, --username [username]", "Spotify Username (required)", null)
	.option("-p, --password [password]", "Spotify Password (required)", null)

	.option("-i, --uri [url / uri]", "Spotify URL / URI (Track / Album / Playlist)", null)

	.option("-d, --directory [directory]", "Download Directory - Default: \"download\" folder within the same directory", getBaseDir())
	.option("-f, --folder [format]", "Save songs in single folder with the playlist name or specified path format - e.g. \"{artist.name}/{album.name}/{track.name}\"")
	#.option("-g, --generate", "Generate file for playlist (PLAYLISTS ONLY!)")

	.option("--sa, --single-artist", "If multiple artist, uses just the first one on ID3 tags")
	.option("--delimiter-path [delimiter]", "Set delimiter to separate multiple artist in paths")
	.option("--delimiter-ID3 [delimiter]", "Set delimiter to separate multiple artist in ID3 tags")

	.parse(process.argv)

config =
	username: Program.username
	password: Program.password

	uri: Program.uri

	directory: Program.directory
	#format: Program.format
	folder: Program.folder
	generate: Program.generate

	onWindows: process.platform == 'win32'

	singleArtist: Program.singleArtist
	_artists_token_delimiter: Program.delimiterPath ? ARTISTS_TOKEN_DELIMITER
	_artists_id3_delimiter: Program.delimiterID3 ? ARTISTS_ID3_DELIMITER

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
