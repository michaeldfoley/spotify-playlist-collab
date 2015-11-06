angular.module 'spotifyPlaylistCollab'
  .directive 'mfsearch', ['$rootScope', 'Spotify', 'playlist', ($rootScope, Spotify, playlist) ->
    restrict: 'E'
    replace: true
    templateUrl: 'app/search/search-template.html'
    link: (scope, elem, attrs) ->
      scope.songQuery = ''
      scope.searchResults = null
      lastSearched = ''
      scope.lastResults = null
      scope.playlist = playlist
      
      $rootScope.$on 'songs.update', (event) ->
        scope.closeSearch()
      
      scope.addSong = (song) ->
        playlist.addSong(scope.userId, scope.playlistId, song)
      
      scope.search = () ->
        if scope.songQuery.length < 3
          scope.searchResults = null
          
        else if scope.songQuery != lastSearched
          Spotify.search(scope.songQuery+'*', 'track')
            .then (data) ->
              scope.searchResults = data.tracks
              scope.lastResults = data.tracks
        
        else
          scope.searchResults = scope.lastResults
          
        
        lastSearched = scope.songQuery
            
      scope.closeSearch = () ->
        scope.searchResults = null
        scope.player.stop()
  ]