angular.module "spotifyPlaylistCollab"
  .controller 'PlaylistCtrl', [
    '$rootScope',
    '$scope',
    '$sce',
    'Spotify',
    ($rootScope, $scope, $sce, Spotify) ->
      $scope.userId = 'michaeldfoley'
      $scope.playlistId = '5L5t7NUqA9xL1wvUFIoaYl'
      $rootScope.token = localStorage.getItem('spotify-token')
      $scope.audio = new Audio()
      $scope.isPlaying = false
      
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
      
      $scope.isMySong = (song) ->
        song.preview_url == $scope.audio.src
      
      $scope.setAudio = (song) ->
        if song.preview_url
          if !$scope.isMySong(song)
            $scope.audio.setAttribute("src", song.preview_url)
            $scope.audio.load()
            $scope.audio.play()
            $scope.previewImg = song.album.images[1].url
            $scope.isPlaying = true
          else
            $scope.togglePlay()
          
      $scope.removeAudio = ->
        $scope.audio.setAttribute("src", null)
        $scope.previewImg = null
        $scope.isPlaying = false
      
      $scope.togglePlay = ->
        if $scope.audio.paused
          $scope.audio.play()
          $scope.isPlaying = true
        else
          $scope.audio.pause()
          $scope.isPlaying = false
      
      $scope.audio.addEventListener 'ended', ->
        $scope.$apply ->
          $scope.removeAudio()
      
      
      
      $scope.search = ->
        Spotify.search($scope.songQuery, 'track')
          .then (data) ->
            $scope.searchResults = data.tracks
            console.log($scope.searchResults)
            
      $scope.closeSearch = ->
        $scope.searchResults = null

      $scope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent) -> resizeSearchResults()
  ]
  
resizeSearchResults = ->
  $('#searchResults').css 'max-height', $(window).height() - $('#searchResults').offset().top - 20 + 'px'
$ ->
  $(window).resize ->
    resizeSearchResults()