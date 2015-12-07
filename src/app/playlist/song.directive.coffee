angular.module 'spotifyPlaylistCollab'
  .directive 'mfsong', ['$rootScope', 'player', ($rootScope, player) ->
    restrict: 'E'
    replace: true
    scope: {
      song: "="
    }
    templateUrl: 'app/playlist/song-template.html'
    link: (scope, elem, attrs) ->
      track = scope.song.track
      controls = elem.children('.song-controls')
      
      if track.preview_url
        controls.prepend('<div class="song-toggle"></div>')
        controls.on 'click', '.song-toggle', () ->
          player.toggle(track)
      
      if scope.song.added_by.id == $rootScope.userId
        controls.append('<div class="song-delete"></div>')
      
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