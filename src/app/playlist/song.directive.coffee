angular.module 'spotifyPlaylistCollab'
  .directive 'mfsong', ['$rootScope', 'player', ($rootScope, player) ->
    restrict: 'E'
    replace: true
    scope: {
      song: "="
    }
    templateUrl: 'app/playlist/song-template.html'
    link: (scope, elem, attrs) ->
      if scope.song.preview_url
        elem.bind 'click', () ->
          if scope.song.preview_url
            player.toggle(scope.song)
      else
        elem.addClass 'no-preview'
      
      $rootScope.$on 'player.playing', () ->
        elem.removeClass 'isPaused'
        if player.thisIsPlaying(scope.song)
          elem.addClass 'isPlaying'
      
      $rootScope.$on 'player.paused', () ->
        elem.removeClass 'isPlaying'
        if player.thisIsPaused(scope.song)
          elem.addClass 'isPaused'
      
      $rootScope.$on 'player.stopped', () ->
        elem.removeClass 'isPlaying isPaused'
  ]