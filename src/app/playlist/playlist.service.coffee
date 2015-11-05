angular.module 'spotifyPlaylistCollab'
  .factory 'playlist', ['$rootScope', 'Spotify', ($rootScope, Spotify) ->
    
    playlist =
    
      songIds: []
      
      getPlaylist: (userId, playlistId, playlistOptions) ->
        if $rootScope.token
          Spotify.getPlaylistTracks(userId, playlistId, playlistOptions)
            .then (data) ->
              playlist.songs = data.items
              angular.forEach(playlist.songs, (item, key) ->
                playlist.songIds.push(item.track.external_ids.isrc)
              )
           
      inPlaylist: (value) ->
        playlist.songIds.indexOf(value) > -1
      
      addSong: (userId, playlistId, song) ->
        if $rootScope.token && !playlist.inPlaylist(song.external_ids.isrc)
          Spotify.addPlaylistTracks(userId, playlistId, song.uri)
          .then () ->
            $rootScope.$broadcast 'songs.update'
            
    return playlist
  ]
  