angular.module 'spotifyPlaylistCollab'
  .directive 'mfplaylist', ['$rootScope', 'playlist', ($rootScope, playlist) ->
    restrict: 'E'
    replace: true
      
    templateUrl: 'app/playlist/playlist-template.html'
    link: (scope, elem, attrs) ->
      playlistOptions = {
        fields: 'items(added_at,added_by(id),track(album(images),artists(name),id,external_ids,name,preview_url))'
      }
      
      scope.playlist = playlist
      getPlaylist = () ->
        playlist.getPlaylist(scope.playlistId.owner, scope.playlistId.id, playlistOptions)
      getPlaylist()
        
  ]