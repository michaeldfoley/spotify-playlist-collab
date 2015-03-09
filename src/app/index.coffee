angular.module 'spotifyPlaylistCollab', [
  'ngAnimate',
  'ngRoute',
  'spotify',
  'ui.unique',
  'offClick']
  .config [
    '$routeProvider',
    '$locationProvider',
    'SpotifyProvider',
    '$httpProvider',
    ($routeProvider, $locationProvider, SpotifyProvider, $httpProvider) ->
    
      $routeProvider
        .when '/',
          templateUrl: 'app/main/main.html'
          controller: 'MainCtrl'
        .when '/playlist',
          templateUrl: 'app/playlist/playlist.html'
          controller: 'PlaylistCtrl'
        .otherwise
          redirectTo: '/'
          
      SpotifyProvider.setClientId '37026114ba074d349b5badec6bda2844'
      SpotifyProvider.setRedirectUri 'http://localhost:3000/spotify-callback.html'
      SpotifyProvider.setScope ''
      
      $locationProvider.html5Mode true
      
      $httpProvider.interceptors.push('authHttpResponseInterceptor')
  ]