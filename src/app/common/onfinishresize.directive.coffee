angular.module 'spotifyPlaylistCollab'
  .directive 'onFinishResize', ($timeout, $window)->
    restrict: 'A'
    link: (scope, element, attr) ->
      if scope.$last == true
      
        resizeTimer = null

        resizeResults = () ->
          resultsBox = angular.element(element.context.parentNode)
          resultsBox.css 'max-height', $window.innerHeight - resultsBox.offset().top - 20 + 'px'
          
        $(window).resize () ->
          $timeout.cancel(resizeTimer)
          resizeTimer = $timeout(resizeResults, 250)
          return
          
        $timeout(resizeResults)
      return