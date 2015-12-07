angular.module 'spotifyPlaylistCollab'
  .factory 'playlist', ['$rootScope', 'Spotify', ($rootScope, Spotify) ->
    
    getPlaylistCount = (userId, playlistId) ->
        if $rootScope.token
          Spotify.getPlaylistTracks(userId, playlistId, {fields:'total'})
          
    playlist =
    
      songIds: []
      
      getPlaylist: (userId, playlistId, playlistOptions) ->
        if $rootScope.token
          # If more than 100 tracks just take the last 100.
          getPlaylistCount(userId, playlistId)
            .then (count) ->
              playlistOptions.offset = if count.total > 100 then count.total - 100 else 0
              
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
            $rootScope.$emit 'songs.update'
            
    return playlist
  ]
  