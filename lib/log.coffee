colors = require('colors')

class Logger
	Error: (msg) =>
		if typeof msg == 'undefined'
			return
		console.log "#{msg}".red

	Success: (msg) =>
		if typeof msg == 'undefined'
			return
		console.log "#{msg}".green

	Info: (msg) =>
		if typeof msg == 'undefined'
			return
		console.log "#{msg}".yellow

	Log: (msg) =>
		if typeof msg == 'undefined'
			return
		console.log " - #{msg}".green

module.exports = Logger
