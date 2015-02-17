receta = angular.module('receta',[
  'templates',
  'restangular',
  'ui.bootstrap',
  'ngRoute',
  'ipCookie',
  'ng-token-auth',
  'ngSanitize',
  'delayed-change',
  'recetaServices',
  'ngDisqus'
])

receta.config([ '$routeProvider','$locationProvider','$disqusProvider','$authProvider',
  ($routeProvider,$locationProvider,$disqusProvider,$authProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
      .when('/recipes/new'
        templateUrl: 'recipes/new.html',
        controller: 'AddRecipeController'
      )
      .when('/recipes/:id'
        templateUrl: 'recipes/show.html',
        controller: 'ViewRecipeController'
      )
      .when('/recipes/:id/edit'
        templateUrl: 'recipes/new.html',
        controller: 'EditRecipeController'
      )
      .when('/users/login',
        templateUrl: 'user_sessions/new.html'
        controller: 'UserSessionsController'
      )
      .when('/users/register',
        templateUrl: 'user_regisrations/new.html'
        controller: 'UserRegistrationsController'
      )
      .when('/users/update-password',
        templateUrl: 'update_password.html'
        controller: 'UserPasswordUpdateController'
      )
      .when('/users/reset-password',
        templateUrl: 'reset_password.html'
        controller: 'UserPasswordResetController'
      )
      # .otherwise(
      #   redirectTo: '/'
      # )

    $locationProvider.html5Mode(true)

    $disqusProvider.setShortname "recipes4you"

    $authProvider.configure({
      authProviderPaths: {
        vkontakte: '/auth/vkontakte'
        github: '/auth/github'
        facebook: '/auth/facebook'
        google_oauth2: '/auth/google_oauth2'
      }
      storage: 'localStorage'
    });
])

.run(->
  console.log "run"
  rm = ()->
    $(".incap_btn-area").fadeOut()

  $(document).ready(()->
    window.setTimeout((-> rm()), 2000)
  )
)