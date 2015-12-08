angular.module 'spotifyPlaylistCollab'
  .directive 'mfalert', ['$rootScope', '$timeout', ($rootScope, $timeout) ->
    restrict: 'E'
    replace: true
      
    templateUrl: 'app/common/alert/alert-template.html'
    link: (scope, elem, attrs) ->
      
      scope.alerts = []
      
      alert = {
        add: (msg, style, id) ->
          scope.alerts.push({
            id: id
            msg: msg
            style: style
          })
          
        remove: (id) ->
          scope.alerts.splice(scope.alerts.indexOf(id), 1)
          
          
        clearAll: () ->
          scope.alerts = []
      }
      
      $rootScope.$on 'songs.update', (event, args) ->
        track = args.song.track
        if args.type == 'add'
          track
          alert.add('Added ' + track.name + '.', 'alert-default', track.id)
          
          
        if args.type == 'remove'
          alert.clearAll()
          alert.add('Removed ' + track.name + '.', 'alert-default', track.id)


        $timeout () ->
          elem.find('.alert').addClass('alert-removing')
            .one 'webkitAnimationEnd oanimationend msAnimationEnd animationend', () ->
              alert.clearAll()
              this.remove()
          return
        , 3000
        
  ]