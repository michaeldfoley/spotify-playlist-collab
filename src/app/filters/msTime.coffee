angular.module 'spotifyPlaylistCollab'
  .filter 'mstotime', ->
    (input) ->
      if int = parseInt(input)
        seconds = ~~((int/1000)%60)
        minutes = ~~((int/(1000*60))%60)
        hours = ~~((int/(1000*60*60))%24)
        
        output = null
        
        output = (if hours < 0 then hours + ':')
        if output
          output += (if minutes < 10 then '0' + minutes else minutes ) + ':'
        else
          output = minutes + ':'
        
        output += (if seconds < 10 then '0' + seconds else seconds )
        
        output