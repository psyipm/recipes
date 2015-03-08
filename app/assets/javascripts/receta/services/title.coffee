angular.module('recetaServices').provider('titleService', 
  ()->
    _sitename = ""
    _pagetitle = ""
    _fulltitle = ""

    @setSiteName = (name)->
      _sitename = name

    @$get = ['$rootScope', ($rootScope)->
      _setTitle = (title)->
        _pagetitle = title
        _fulltitle =  title + " - " + _sitename

        $("title").text(_fulltitle)
        return

      _listen = ()->
        $rootScope.$on('$routeChangeSuccess', (event, current, previous)->
          if current.$$route.title
            _setTitle(current.$$route.title)
        )

      return {
        init: _listen

        getSiteName: ()->
          _sitename

        setTitle: _setTitle

        getTitle: ()->
          _fulltitle

        getPageTitle: ()->
          _pagetitle
      }
    ]
    return
)