angular.module 'spotifyPlaylistCollab'
  .factory 'player', ['audio', '$rootScope', (audio, $rootScope) ->
    
    player =
      current: null
      isPlaying: false
      previewImg: null
      
      play: (song) ->
        url = song.preview_url
        if player.isPlaying 
          player.stop()
        if !player.isCurrent(url)
          player.current = audio.src = url
          player.previewImg = song.album.images[1].url
        audio.play()
        player.isPlaying = true
      
      pause: () ->
        if player.isPlaying
          audio.pause()
          player.isPlaying = false
      
      stop: () ->
        if player.isPlaying 
          player.pause()
          player.previewImg = player.current = audio.src = null
      
      isCurrent: (track) ->
        player.current && player.current == track
      
      thisIsPlaying: (track) ->
        player.isPlaying && player.isCurrent(track.preview_url)
      
      thisIsPaused: (track) ->
        !player.isPlaying && player.isCurrent(track.preview_url)
        
      toggle: (song) ->
        if player.isPlaying && player.isCurrent(song.preview_url)
          player.pause()
        else
          player.play(song)
    
    audio.addEventListener 'ended', () ->
      $rootScope.$apply () ->
        player.stop()
    
    return player
  ]
  