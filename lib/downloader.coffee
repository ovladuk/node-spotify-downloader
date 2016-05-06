Logger = require("./log")
Logger = new Logger()
Track = require("./track")

fs = require("fs")
async = require("async")
lodash = require("lodash")
spotifyWeb = require("spotify-web")
EventEmitter = require("events").EventEmitter

class Downloader extends EventEmitter
	constructor: (@config) ->
		@data = {
			trackCount: 0
		}
		@Track = new Track()

	run: =>
		async.series [@login, @handleType, @handleDownload], (err, res) =>
			if err
				Logger.Log "#{res.toString()}"
				return Logger.Error "#{err.toString()}"

			Logger.Success ' ------- DONE ALL ------- '
			process.exit(0)

	login: (callback) =>
		spotifyWeb.login @config.username, @config.password, (err, SpotifyInstance) =>
			if err
				return Logger.Error "Error logging in... (#{err})"

			Logger.Log "Login successful!"

			@spotify = SpotifyInstance
			@Track.setSpotify @spotify
			callback?()

	handleType: (callback) =>
		if @config.type == "playlist" # Good ol' playlists
			Logger.Log "Handling playlist ..."

			@spotify.playlist @config.uri, 0, 9001, (err, data) =>
				if err
					return Logger.Error "Playlist data error... #{err}"

				Logger.Log "Playlist: #{data.attributes.name}"

				@data.name = data.attributes.name

				if @config.folder
					@config.directory = @config.directory + "/" + @data.name.replace(/\//g, "-") + "/"

				@data.tracks = lodash.map data.contents.items, (track) =>
					@data.trackCount += 1
					return track.uri

				callback?()

		else if @config.type == "album" # Albums! \o/
			Logger.Log "Handling album ..."

			@spotify.get @config.uri, (err, album) =>
				if err
					return Logger.Error "Album data error... #{err}"

				Logger.Log "Album: #{album.name}"

				@data.name = album.name

				if @config.folder
					@config.directory = @config.directory + "/" + @data.name.replace(/\//g, "-") + " [#{album.date.year}]" + "/"

				tracks = []
				album.disc.forEach (disc) =>
					if Array.isArray(disc.track)
						tracks.push.apply tracks, disc.track

				@data.tracks = lodash.map tracks, (track) =>
					@data.trackCount += 1
					return track.uri

				callback?()

		else if @config.type == "track" # Single tracks, aww yiss
			Logger.Log "Handling track ..."

			@data.tracks = [@config.uri]

			@data.trackCount = 1

			callback?()

		else if @config.type == "library" # Saved tracks! :O
			Logger.Log "Handling library ..."

			@spotify.library @config.username, 0, 9001, (err, data) =>
				if err
					return Logger.Error "Library data error... #{err}"

				if @config.folder
					@config.directory = @config.directory + "/Library/"

				@data.tracks = lodash.map data.contents.items, (track) =>
					@data.trackCount += 1
					return track.uri

				callback?()

	handleDownload: (callback) =>
		Logger.Log "Processing #{@data.trackCount} tracks"

		async.mapSeries @data.tracks, @processTrack, callback

	processTrack: (uri, callback) =>
		uriType = spotifyWeb.uriType uri
		if uriType == "local"
			Logger.Info "Skipping Local Track: #{uri}"
			return @callback?()
		@Track.process uri, @config, callback

module.exports = Downloader
