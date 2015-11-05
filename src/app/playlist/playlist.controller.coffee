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
      userId = 'michaeldfoley'
      playlistId = '5L5t7NUqA9xL1wvUFIoaYl'
      playlistOptions = {
        fields: 'items(added_at,added_by(id),track(album(images),artists(name),external_ids,name,preview_url))'
      }
      $rootScope.token = localStorage.getItem('spotify-token')
      $scope.player = player
      $scope.playlist = playlist
      $scope.songQuery = ''
      $scope.lastSearched = ''
      
      $scope.init = () ->
        if $rootScope.token
          Spotify.setAuthToken($rootScope.token)
          $scope.getPlaylist()
      
      $scope.login = () ->
        Spotify.login()
        .then (data) ->
          $rootScope.token = data
          $scope.getPlaylist()
      
      $scope.getPlaylist = () ->
        playlist.getPlaylist(userId, playlistId, playlistOptions)
      
      $scope.$on 'songs.update', (event) ->
        $scope.getPlaylist()
        $scope.closeSearch()
      
      $scope.addSong = (song) ->
        playlist.addSong(userId, playlistId, song)
      
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