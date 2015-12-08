angular.module 'spotifyPlaylistCollab'
  .directive 'mfsong', ['$rootScope', 'player', 'playlist', ($rootScope, player, playlist) ->
    restrict: 'E'
    replace: true
    scope: {
      song: "="
      playlistId: "=playlist"
    }
    templateUrl: 'app/playlist/song-template.html'
    link: (scope, elem, attrs) ->
      track = scope.song.track
      controls = elem.children('.song-controls')
      
      if track.preview_url
        controls.prepend('<div class="song-toggle"></div>')
        controls.on 'click', '.song-toggle', () ->
          player.toggle(track)
      
      if scope.song.added_by.id == $rootScope.userId && scope.playlistId
        controls.append('<div class="song-delete"></div>')
        controls.on 'click', '.song-delete', () ->
          playlist.removeSong(scope.playlistId.owner, scope.playlistId.id, scope.song)
      
      $rootScope.$on 'player.playing', () ->
        elem.removeClass 'isPaused'
        if player.thisIsPlaying(track)
          elem.addClass 'isPlaying'
      
      $rootScope.$on 'player.paused', () ->
        elem.removeClass 'isPlaying'
        if player.thisIsPaused(track)
          elem.addClass 'isPaused'
      
      $rootScope.$on 'player.stopped', () ->
        elem.removeClass 'isPlaying isPaused'
  ]