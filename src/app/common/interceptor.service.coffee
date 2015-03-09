angular.module 'spotifyPlaylistCollab'
  .factory 'authHttpResponseInterceptor', [
    '$q', '$rootScope',
    ($q, $rootScope) ->
    
      response: (response) ->
        response or $q.when(response)
      responseError: (rejection) ->
        console.log(rejection)
        if rejection.status == 401
          $rootScope.token = ''
          localStorage.setItem('spotify-token', '')
        $q.reject rejection
  ]
  