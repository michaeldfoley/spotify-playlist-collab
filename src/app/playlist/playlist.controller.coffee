angular.module "spotifyPlaylistCollab"
  .controller 'PlaylistCtrl', [
    '$rootScope',
    '$scope',
    '$timeout',
    'Spotify',
    'audio',
    'player',
    'playlist',
    ($rootScope, $scope, $timeout, Spotify, audio, player, playlist) ->
      $rootScope.token = localStorage.getItem('spotify-token')
      $scope.player = player
      $scope.userId = 'michaeldfoley'
      $scope.playlistId = '5L5t7NUqA9xL1wvUFIoaYl'
    

      $scope.songQuery = ''
      $scope.lastSearched = ''
      
      $scope.init = () ->
        if $rootScope.token
          Spotify.setAuthToken($rootScope.token)
      
      $scope.login = () ->
        Spotify.login()
        .then (data) ->
          $rootScope.token = data
      
      $rootScope.$on 'songs.update', (event) ->
        $scope.closeSearch()
      
      $scope.addSong = (song) ->
        playlist.addSong($scope.userId, $scope.playlistId, song)
      
      $scope.search = () ->
        if $scope.songQuery.length < 3
          $scope.searchResults = null
          
        else if $scope.songQuery != $scope.lastSearched
          Spotify.search($scope.songQuery+'*', 'track')
            .then (data) ->
              $scope.searchResults = data.tracks
        
        $scope.lastSearched = $scope.songQuery
            
      $scope.closeSearch = () ->
        $scope.searchResults = null
        $scope.player.stop()
  ]