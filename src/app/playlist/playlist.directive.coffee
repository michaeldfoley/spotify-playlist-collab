angular.module 'spotifyPlaylistCollab'
  .directive 'mfplaylist', ['$rootScope', 'playlist', ($rootScope, playlist) ->
    restrict: 'E'
    replace: true
    scope: {
      userId: "@user"
      playlistId: "@playlist"
    }
      
    templateUrl: 'app/playlist/playlist-template.html'
    link: (scope, elem, attrs) ->
      playlistOptions = {
        fields: 'items(added_at,added_by(id),track(album(images),artists(name),external_ids,name,preview_url))'
      }
      scope.playlist = playlist
      getPlaylist = () ->
        playlist.getPlaylist(scope.userId, scope.playlistId, playlistOptions)
      getPlaylist()
      
      $rootScope.$on 'songs.update', () ->
        getPlaylist()
        
  ]