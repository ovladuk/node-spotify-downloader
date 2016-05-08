
objTypeof = (obj) -> Object.prototype.toString.call(obj)

deepMap = (obj) ->
	dp = deepMap.bind(@)
	if objTypeof(obj) == "[object Array]"
		obj.map( dp )
	else if objTypeof(obj) == "[object Object]"
		for own k,v of obj
			obj[k] = dp(v)
		obj
	else
		@fn?(obj) ? obj

module.exports = { objTypeof, deepMap }
