angular.module "spotifyPlaylistCollab"
  .controller "NavbarCtrl", ($scope, $location) ->
    $scope.date = new Date()
    
    $scope.isActive = (viewLocation) ->
      viewLocation == $location.path()
