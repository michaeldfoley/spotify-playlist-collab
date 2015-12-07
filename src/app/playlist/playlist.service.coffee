angular.module 'spotifyPlaylistCollab'
  .factory 'playlist', ['$rootScope', 'Spotify', ($rootScope, Spotify) ->
    
    getPlaylistCount = (playlistOwnerId, playlistId) ->
      if $rootScope.token
        Spotify.getPlaylistTracks(playlistOwnerId, playlistId, {fields:'total'})
          
    playlist =
    
      getUserId: () ->
        if $rootScope.token
          Spotify.getCurrentUser()
            .then (data) ->
              $rootScope.userId = data.id
      
      songIds: []
      
      getPlaylist: (playlistOwnerId, playlistId, playlistOptions) ->
        if $rootScope.token
          playlist.getUserId()
          # If more than 100 tracks just take the last 100.
          getPlaylistCount(playlistOwnerId, playlistId)
            .then (count) ->
              playlistOptions.offset = if count.total > 100 then count.total - 100 else 0
              
              Spotify.getPlaylistTracks(playlistOwnerId, playlistId, playlistOptions)
                .then (data) ->
                  playlist.songs = data.items
                  angular.forEach(playlist.songs, (item, key) ->
                    playlist.songIds.push(item.track.external_ids.isrc)
                  )
           
      inPlaylist: (value) ->
        playlist.songIds.indexOf(value) > -1
      
      addSong: (playlistOwnerId, playlistId, song) ->
        if $rootScope.token && !playlist.inPlaylist(song.external_ids.isrc)
          Spotify.addPlaylistTracks(playlistOwnerId, playlistId, song.uri)
          .then () ->
            $rootScope.$emit 'songs.update'
            
    return playlist
  ]
  