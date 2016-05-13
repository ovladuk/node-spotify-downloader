
objTypeof = (obj) -> Object.prototype.toString.call(obj)

chkFn = (fn) -> if typeof fn == "function" then fn else (o)->o

deepMap = (obj) ->
	dp = deepMap.bind(@)
	if objTypeof(obj) == "[object Array]"
		chkFn(@array)( obj.map(dp) )
	else if objTypeof(obj) == "[object Object]"
		for own k,v of obj
			obj[k] = dp(v)
		chkFn(@object)(obj)
	else
		chkFn(@fn)(obj)

fixPathPiece = (piece) ->
	#piece.replace /[/\\?%*:|"<>]/g, ""
	piece.split(/[\/\\?%*:|"<>]/g).filter((i)->!!i).join(" ")


module.exports = { objTypeof, deepMap, fixPathPiece }
