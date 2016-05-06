fs = require("fs")
mkdirp = require("mkdirp")
id3 = require("node-id3")
domain = require("domain")
request = require("request")
Path = require("path")
Logger = require("./log")
Logger = new Logger()

class Track
	constructor: (@uri, @config, @callback) ->
		@track = {}
		@file = {}
		@retryCounter = 0

	setSpotify: (@spotify) ->

	process: (@uri, @config, @callback) =>
		@spotify.get @uri, (err, track) =>
#			restriction = track.restriction[0]
#			if !restriction.countriesForbidden? and restriction.countriesAllowed == ""
#				Logger.Error "Song is not available anymore."
#				@callback?()
			if err
				return @callback? err

			@track = track
			@createDirs()

	fixFilename: =>
		@file.name = @file.name.replace /[/\\?%*:|"<>]/g, ""

	createDirs: =>
		@config.directory = Path.resolve @config.directory

		@file.name = @track.name.replace(/\//g, " - ")
		@file.path = @config.directory + "/" + @fixFilename(@file.name) + ".mp3"

		if fs.existsSync @file.path
			stats = fs.statSync @file.path
			if stats.size != 0
				Logger.Info "Already downloaded: #{@track.artist[0].name} - #{@track.name}"
				return @callback?()

		if !fs.existsSync @config.directory
			mkdirp.sync @config.directory

		@downloadCover()
		@downloadFile()

	downloadCover: =>
		coverPath = "#{@file.path}.jpg"
		coverUrl = "#{@track.album.coverGroup.image[2].uri}"
		request.get coverUrl
  	.on "error", (err) =>
    	Logger.Error "Error while downloading cover: #{err}"
  	.pipe fs.createWriteStream coverPath
		Logger.Log "Cover downloaded: #{@track.artist[0].name} - #{@track.name}"

	downloadFile: =>
		Logger.Log "Downloading: #{@track.artist[0].name} - #{@track.name}"

		d = domain.create()
		d.on "error", (err) =>
			Logger.Error "Error received: #{err}"
			if "#{err}".indexOf("Rate limited") > -1
				Logger.Info "#{err} ... { Retrying in 10 seconds }"
				if @retryCounter < 2
					@retryCounter++
					setTimeout @downloadFile, 10000
				else
					Logger.Error "Unable to download song. Continuing"
					@callback?()
			else
				return @callback?()
		d.run =>
			out = fs.createWriteStream @file.path
			try
				@track.play().pipe(out).on "finish", =>
					Logger.Log "Done: #{@track.artist[0].name} - #{@track.name}"
					@writeMetadata()
			catch err
				Logger.Error "Error while downloading track! #{err}"
				@callback?()

	writeMetadata: =>
		meta =
			artist: @track.artist[0].name
			album: @track.album.name
			title: @track.name
			year: "#{@track.album.date.year}"
			trackNumber: "#{@track.number}"
			image: "#{@file.path}.jpg"

		id3.write meta, @file.path
		fs.unlink meta.image
		return @callback?()

module.exports = Track
