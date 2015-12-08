angular.module 'spotifyPlaylistCollab'
  .factory 'playlist', ['$rootScope', 'Spotify', '$filter', ($rootScope, Spotify, $filter) ->
    
    getPlaylistCount = (playlistOwner, playlistId) ->
      if $rootScope.token
        Spotify.getPlaylistTracks(playlistOwner, playlistId, {fields:'total'})
    
    songsUpdated = (type, song) ->
      $rootScope.$emit 'songs.update',
        type: type
        song: song
       
    playlist =
    
      getUserId: () ->
        if $rootScope.token
          Spotify.getCurrentUser()
            .then (data) ->
              $rootScope.userId = data.id
      
      songIds: []
      
      getPlaylist: (playlistOwner, playlistId, playlistOptions) ->
        if $rootScope.token
          playlist.getUserId()
          # If more than 100 tracks just take the last 100.
          getPlaylistCount(playlistOwner, playlistId)
            .then (count) ->
              playlistOptions.offset = if count.total > 100 then count.total - 100 else 0
              Spotify.getPlaylistTracks(playlistOwner, playlistId, playlistOptions)
                .then (data) ->
                  playlist.songs = data.items
                  playlist.songIds = []
                  angular.forEach(playlist.songs, (item, key) ->
                    playlist.songIds.push(item.track.external_ids.isrc)
                  )
           
      inPlaylist: (value) ->
        playlist.songIds.indexOf(value) > -1
      
      addSong: (playlistOwner, playlistId, song) ->
        if $rootScope.token && !playlist.inPlaylist(song.external_ids.isrc)
          playlistItem = {added_at: $filter('date')(Date.now(), 'yyyy-MM-ddTHH:mm:ss', 'UTC') + 'Z', added_by: {id: $rootScope.userId}, track: song}
          
          playlist.songs.push(playlistItem)
          playlist.songIds.push(song.external_ids.isrc)
          
          Spotify.addPlaylistTracks(playlistOwner, playlistId, song.uri)
            .then () ->
              songsUpdated('add', playlistItem)
            
      removeSong: (playlistOwner, playlistId, song) ->
        if song.added_by.id == $rootScope.userId
          playlist.songs.splice(playlist.songs.indexOf(song), 1)
          playlist.songIds.splice(playlist.songIds.indexOf(song.track.external_ids.isrc), 1)
          
          Spotify.removePlaylistTracks(playlistOwner, playlistId, song.track.id)
            .then () ->
              songsUpdated('remove', song)
            
    return playlist
  ]
  