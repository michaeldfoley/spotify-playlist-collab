angular.module "spotifyPlaylistCollab"
  .controller 'PlaylistCtrl', [
    '$rootScope',
    '$scope',
    '$timeout',
    'Spotify',
    'audio',
    'player',
    ($rootScope, $scope, $timeout, Spotify, audio, player) ->
      $scope.userId = 'michaeldfoley'
      $scope.playlistId = '5L5t7NUqA9xL1wvUFIoaYl'
      $rootScope.token = localStorage.getItem('spotify-token')
      $scope.player = player
      $scope.songQuery = ''
      $scope.lastSearched = ''
      $scope.songIds = []
      
      $scope.init = ->
        if $rootScope.token
          Spotify.setAuthToken($rootScope.token)
          $scope.getPlaylist()
      
      $scope.login = ->
        Spotify.login()
        .then (data) ->
          $rootScope.token = data
          $scope.getPlaylist()
      
      $scope.getPlaylist = ->
        if $rootScope.token
          Spotify.getPlaylistTracks($scope.userId, $scope.playlistId)
            .then (data) ->
              $scope.songs = data.items
              angular.forEach($scope.songs, (item, key)->
                $scope.songIds.push(item.track.external_ids.isrc)
              )
      
      $scope.search = ->
        if $scope.songQuery.length < 3
          $scope.searchResults = null
          
        else if $scope.songQuery != $scope.lastSearched
          Spotify.search($scope.songQuery+'*', 'track')
            .then (data) ->
              $scope.searchResults = data.tracks
        
        $scope.lastSearched = $scope.songQuery
            
      $scope.closeSearch = ->
        $scope.searchResults = null
        $scope.player.stop()
      
      $scope.inPlaylist = (value)->
        $scope.songIds.indexOf(value) > -1
      
      $scope.add = (song)->
        if $rootScope.token
          Spotify.addPlaylistTracks($scope.userId, $scope.playlistId, song.uri)
            .then (data)->
              $scope.getPlaylist()
              $scope.closeSearch()

      $scope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent) -> resizeSearchResults()
  ]
  
resizeSearchResults = ->
  $('#searchResults').css 'max-height', $(window).height() - $('#searchResults').offset().top - 20 + 'px'
$ ->
  $(window).resize ->
    resizeSearchResults()