angular.module 'spotifyPlaylistCollab'
  .directive 'mfplaylist', ['$rootScope', ($rootScope) ->
    restrict: 'E'
    replace: true
    scope: {
      songs: "="
    }
      
    templateUrl: 'app/playlist/playlist-template.html'
    link: (scope, elem, attrs) ->
  ]