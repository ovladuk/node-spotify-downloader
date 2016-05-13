colors = require('colors')

class Logger

	_getIndent: (i) =>
		idnt = '\ \ '
		if i and typeof i == "number" then " #{idnt.repeat(i-1)}- " else ''

	Error: (msg, i) =>
		if typeof msg == 'undefined'
			return
		idnt = @_getIndent(i)
		console.log "#{idnt}#{msg}".red

	Success: (msg, i) =>
		if typeof msg == 'undefined'
			return
		idnt = @_getIndent(i)
		console.log "#{idnt}#{msg}".green

	Info: (msg, i) =>
		if typeof msg == 'undefined'
			return
		idnt = @_getIndent(i)
		console.log "#{idnt}#{msg}".yellow

	Log: (msg, i) =>
		if typeof msg == 'undefined'
			return
		idnt = @_getIndent(i)
		console.log "#{idnt}#{msg}"

module.exports = Logger
