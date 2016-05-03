# node-spotify-downloader

A CLI and GUI solution to download music from Spotify
[![Join the chat at https://gitter.im/Lordmau5/node-spotify-downloader](https://badges.gitter.im/Lordmau5/node-spotify-downloader.svg)](https://gitter.im/Lordmau5/node-spotify-downloader?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Download entire Spotify playlists, albums or tracks (directly from Spotify at 160kbps) to your local machine.

###Prerequisites:
Install NodeJS if you haven't already. ([NodeJS Downloads](http://nodejs.org/download/))

###Usage

	Usage: node main.js [options]

	Options:

	    -h, --help                   output usage information
	    -V, --version                output the version number
	    -u, --username [username]    Spotify Username (required)
	    -p, --password [password]    Spotify Password (required)
	    -i, --uri 	   [URI / URL]   Spotify URI / URL for playlist, album or track
	    -d, --directory [directory]  Download Directory - Default: "downloads" folder within the same directory
	    -f, --folder                 Save songs in single folder with the playlist name (PLAYLISTS ONLY!)



####So:
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

### Disclaimer:

- Don't use it ( ͡° ͜ʖ ͡°)
