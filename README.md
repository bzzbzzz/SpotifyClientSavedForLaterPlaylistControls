SpotifyClientSavedForLaterPlaylistControls
==========================================

helper app to star the track currently playing in the spotify client and eventually remove it from a "to listent to later" kind of playlist.
or just remove the track from that playlist and skip to the next track.

only works with spotify premium account (libspotify API needs premium accounts)

needs to be run with either argument star or argument remove, just quits, doing nothing, otherwise
( e.g. alfred: open -n SpotifySavedForLater.app --args -savedForLater {query} )

currently alpha:

star:
If you have a Playlist called "testPlaylist" as first playlist (on the top) in your	Spotify Client, "star" will star the current track and remove it from the list without stopping it (meant as a "to listen to later"playlist)
TAKES SOME TIME FOR YOUR APP TO DISPLAY IT IS REALLY STARRED, CHANGE HAPPENS ON THEIR SERVERS

remove:
similar to star. it doesn't star the track, though. just removes the track from the playlist and skips to the next track immediately. 
