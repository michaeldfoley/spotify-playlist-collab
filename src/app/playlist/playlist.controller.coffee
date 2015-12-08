angular.module "spotifyPlaylistCollab"
  .controller 'PlaylistCtrl', [
    '$rootScope',
    '$scope',
    'Spotify',
    'player',
    ($rootScope, $scope, Spotify, player) ->
      $rootScope.token = localStorage.getItem('spotify-token')
      $scope.player = player
      $scope.playlistId =
        owner: 'michaeldfoley'
        id: '5L5t7NUqA9xL1wvUFIoaYl'
      
      $scope.init = () ->
        if $rootScope.token
          Spotify.setAuthToken($rootScope.token)
              
      
      $scope.login = () ->
        Spotify.login()
          .then (data) ->
            $rootScope.token = data
  ]