receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'ipCookie',
  'ngResource',
  'ng-token-auth',
  'ngSanitize',
  'delayed-change',
  'controllers',
  'recetaServices'
])
.directive "recipeListRenderingDirective", ->
  (scope, element, attrs) ->
    fotorama = ()->
      window.setTimeout(()->
        $(".fotorama").fotorama()
      , 100)

    fotorama() if scope.$last
    return

receta.config([ '$routeProvider','$locationProvider',
  ($routeProvider,$locationProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
      .when('/users/sign_in',
        templateUrl: 'user_sessions/new.html'
        controller: 'UserSessionsController'
      )
      .when('/users/register',
        templateUrl: 'user_regisrations/new.html'
        controller: 'UserRegistrationsController'
      )
      .otherwise(
        redirectTo: '/'
      )

    # $locationProvider.html5Mode(true)
])