# node-spotify-downloader

# ACTUALLY THE PROJECT IS NOT WORKING, LOOKING FOR A SOLUTION.

A community driven CLI and GUI solution to download music from Spotify
[![Join the chat at https://gitter.im/Lordmau5/node-spotify-downloader](https://badges.gitter.im/Lordmau5/node-spotify-downloader.svg)](https://gitter.im/Lordmau5/node-spotify-downloader?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Download entire Spotify playlists, albums or tracks (directly from Spotify at 160kbps) to your local machine.

![cli demo](http://i.imgur.com/R1aKQ4Z.png)

### Features
- ID3 tags
- Album art image
- Download entire library
- Custom folder hierarchy

### Known problems
- ID3 tags don't work with Unicode characters
- Not possible to download 320kbps (limitation of Spotify Web)

### Prerequisites
- Install NodeJS **(v4.4.4 LTS)** if you haven't already. ([NodeJS Downloads](https://nodejs.org/en/))
- Download this repository as a .zip archive
- Unpack the contents to a folder of your choice
- Run `npm install` from a commandline

### CLI Usage

	Usage: node main.js [options]

	Options:

	    -h, --help                   output usage information
	    -V, --version                output the version number
	    -u, --username [username]    Spotify Username (required)
	    -p, --password [password]    Spotify Password (required)
	    -c, --captcha  [captcha]      ReCaptcha2 (required)
		
	    -s, --fbuid  [fbuid]          facebook uid   (required) alternative
 	    -t, --fbtoken [fbToken]       facebook token (required) alternative		
		
	    -i, --uri 	   [URI / URL]   Spotify URI / URL for playlist, album or track - another valid input for this is "library"
	    -d, --directory [directory]  Download Directory - Default: "download" folder within the same directory
	    -f, --folder                 Create a sub-directory for playlist / album / library or specify folder hierarchy format

#### captcha & Facebook login
Here is some working sample with both
Normal and Facebook Login:
node main.js ^
	--uri https://play.spotify.com/track/4WF7zntvHfsUAw0m3noWby ^
	--username bugmenot@mailinator2.com ^
	--password qweasd ^
	--captcha ^
03AHJ_VuuBfXWLdhJbG_VujUm6DKGzV3xpTWBZmhjecWbD57e4gA0iD2iYM_eDfOCZPTnZIWU205FMvtOtVfD4hCgHtpnvPsC_GKLN41sOGQpcmkPypg11sJS5cNOPrAExQTFH0cLqdGo1pB3-J8N240LB3quMt32iqZgEcNohjZQE4MyGBP1wXWkwdezzJ_JDjJ1-QXrlp8MBT82qWEb_tNHQ6qc0kvb6s_5wWbbgib7SSFoeKQFYWzGLsQX69WdfYhBdHkxx4FCkSLD6CokGFPPumSGtMesHV3r6haY2Ecw3qt8syiYex7MpZb1TVuR_F9rtu9ue-a5Wbc0H0YFSBQlkPbbPVTFyYNhylMIKL_xBGcKOzfK82K2e2Je_H3lUkoliROA4Xma9RomKHXhbbVIHt2o3b_8FC632kMQNR-LGxXq6Wz6CZZg2T_Hw-9EfLjTXedXJrAneelBhQxjW3vcwUVpt3Cu1KUv_6y-0GetsHFiwp7d8IBBly-iXHGn9UlTLm-w5Kd0excXyTGMcrI7Kwux52a-62i6l_CtIsx8B2M3PLyvZU9ra3wBAF-fjDtnObfAwIP0TH_vAwUzBs91_8pwDrqcBp32OyLHw51gHFKhRbV4t8HaXQXDltEmS-Ot3JH43Fnf-if6xGueV210Y7xgqVlfDsOvttdoO5IKtb-T4_6xhtT0vzpHpcM3mxGQuIqBHK2M3E7SXOXXMSsArHlF0bKVFzGxp4UjHLoisVxrET_SwUDElvL1Ohkf1O4FbU2JoLpyRt7R2FNTo7QvQW9ehmK32-Wvc2y71TbIGk3ttjfpl2EWlgJNooR2l0NjpCafleu_dZy8LY4_giLGfscrbPYnWcj7ZQ7wv-SJcBpS-EgrNN-BKyHf-Wjv-RERVYVrQ3Osne-WbLW2Wq1h6djoHQ0qS4FSqKBci8JddKRGP3UK-oGebMzKL7-mgfjZMUeeVNyT9g4zYZuANKRmup823lX523Q ^
	^
	--fbuid 100407737077319 ^
	--fbtoken EAAAAKLSe4lIBAEEiksijLZCbkXuIL3BFEnHTFU5x78PrxmjHfIDVsex1Mz0yWFGHLsyTmlONp6gvATBrFttbu4X2DkekXEgrWcuDW1jqfgl3WPfdCCgfeUbrFus4CZCoK2ZCrnEpQ3TZAylt3IRrCr1hGbCnnQOCFWhZAJeClJQZDZD ^

To get --fbuid 	--fbtoken just what over the should of http://play.spotify.com/ when doing the login via Facebook
watch for the form of https://play.spotify.com/xhr/json/auth.php being submited and get authfbuid token from there.
You can do that by the developers Tools/Network in Firefox &Chrome.

For normal login you'll need additionally a catcha.
1. Save this bookmarklet: 
Spotify Captcha Ripper
javascript:a=document.querySelector('.g-recaptcha-response');a.style.display='';a.select();a.focus();1
2. Solve the Captcha on Spotify Webplayer Login
3. Run the bookmarklet to make the hidden Captcha result field visible. Copy the value and pass it via 
--captcha

captcha is only valid once so you need to redo this on each login.
So far at the moment Facebook login is really recommended.
TO DO:
However we may extent the code so you may pass also the sessionID you get on each
valid login so after a successfully login you can reuse that without a new login + captcha


		
#### So
  If you wanted to download the playlist "Top 100 Hip-Hop Tracks on Spotify", you would use the following command:
	
	node main.js -u yourusername -p yourpassword -i spotify:user:spotify:playlist:06KmJWiQhL0XiV6QQAHsmw
	OR
	node main.js -u yourusername -p yourpassword -i https://play.spotify.com/user/spotify/playlist/06KmJWiQhL0XiV6QQAHsmw

  If you wanted to download the album "Epiphany", you would use the following command:

	node main.js -u yourusername -p yourpassword -i spotify:album:44Z1ZEmOyois0QoAgfUxrD
	OR
	node main.js -u yourusername -p yourpassword -i https://play.spotify.com/album/44Z1ZEmOyois0QoAgfUxrD

  If you wanted to download the track "2Pac I Get Around", you would use the following command:

	node main.js -u yourusername -p yourpassword -i spotify:track:74kHlIr01X459gqsSdNilW
	OR
	node main.js -u yourusername -p yourpassword -i https://play.spotify.com/track/74kHlIr01X459gqsSdNilW

#### Path format
If you pass `-f` flag without specifying a file path template, it will save the
songs inside a folder with the name of the album/playlist, or inside a `Library`
folder in case you are downloading all saved songs (`-i library`).

If you want to specify a path template, the following tokens are available:

- `{track.name}`
- `{track.number}`
- `{track.artists}` (list of track artists names separated by a comma)
- `{artist.name}` (name of the first artist)


- `{album.name}`
- `{album.year}`
- `{album.artists}`


- `{user}` (user name used for downloading)
- `{id}` (ID of what is being downloaded)
- `{b64uri}` (Spotify URI to be downloaded, base64 encoded)

In case of playlists and library, these tokens are also available:

- `{playlist.name}` ("Library" in case of library download)
- `{playlist.trackCount}` (the total number of tracks in the playlist or library)
- `{playlist.user}` (owner of the playlist)
- `{index}` (the index of the track in the playlist or library, not in the album it belogs to)

To get the ID of a track, album, artist or playlist, use the respective `.id` attribute (`{track.id}`, `{album.id}`, `{artist.id}`, or `{playlist.id}`).  
The same thing applies to the `.b64uri` attribute, which return a base64 version of the resource's URI.

e.g. `-f "{artist.name}/{album.name} [{album.year}]/{track.name}"`
will result in: `Rammstein/Mutter [2001]/Sonne.mp3`

e.g. `-f "{playlist.name}/{index} - {artist.name} - {track.name}"` for a playlist:
will result in `My playlist/18 - The Artist - The Song.mp3`

e.g. `-f "{artist.name} - {album.name} [{album.year}]/{track.number} - {artist.name} - {track.name}"` for an album:
will result in `The Artist - The Album [2015]/18 - The Artist - The Song.mp3`

Passing `-f legacy` will result in the format:
`{artist.name}/{album.name} [{album.year}]/{artist.name} - {track.name}`


### To run it from a Web browser
  To open in browser, just run from terminal/cmd file run.sh/run.bat (depends of your OS)
    this file will install all needed modules an start a local server (address will be displayed in terminal, by default is http://localhost:3001).
    Just open this address in your browser and ... enjoy :)


### Disclaimer
- Don't use it ( ͡° ͜ʖ ͡°)
