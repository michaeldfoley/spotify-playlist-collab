angular.module 'spotifyPlaylistCollab'
  .directive 'onFinishResize', ($timeout, $window)->
    restrict: 'A'
    link: (scope, element, attr) ->
      if scope.$last == true
        $timeout ->
          resultsBox = angular.element(element.context.parentNode)
          
          resultsBox.css 'max-height', $window.innerHeight - resultsBox.offset().top - 20 + 'px'
      return