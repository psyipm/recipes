receta = angular.module('receta',[
  'templates',
  'restangular',
  'ui.bootstrap',
  'ngRoute',
  'ipCookie',
  'ng-token-auth',
  'ngSanitize',
  'delayed-change',
  'recetaServices'
])

receta.config([ '$routeProvider','$locationProvider','$authProvider','titleServiceProvider',
  ($routeProvider,$locationProvider,$authProvider,titleServiceProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
        title: "Поиск кулинарных рецептов"
      )
      .when('/recipes/new'
        templateUrl: 'recipes/new.html'
        controller: 'AddRecipeController'
        title: "Добавить рецепт"
      )
      .when('/recipes/:id'
        templateUrl: 'recipes/show.html'
        controller: 'ViewRecipeController'
      )
      .when('/recipes/:id/edit'
        templateUrl: 'recipes/new.html'
        controller: 'EditRecipeController'
        restricted: true
        title: "Редактировать рецепт"
      )
      .when('/users/login',
        templateUrl: 'user_sessions/new.html'
        controller: 'UserSessionsController'
        title: "Авторизация"
      )
      .when('/users/register',
        templateUrl: 'user_regisrations/new.html'
        controller: 'UserRegistrationsController'
        title: "Регистрация"
      )
      .when('/users/update-password',
        templateUrl: 'update_password.html'
        controller: 'UserPasswordUpdateController'
        restricted: true
        title: "Редактирование пароля"
      )
      .when('/users/reset-password',
        templateUrl: 'reset_password.html'
        controller: 'UserPasswordResetController'
        title: "Восстановление пароля"
      )
      .otherwise(
        redirectTo: '/'
      )

    $locationProvider.html5Mode(true)
    $locationProvider.hashPrefix('!');

    $authProvider.configure({
      authProviderPaths: {
        vkontakte: '/auth/vkontakte'
        github: '/auth/github'
        facebook: '/auth/facebook'
        google_oauth2: '/auth/google_oauth2'
      }
      storage: 'localStorage'
    });

    titleServiceProvider
      .setSiteName('Recipes4You')
])

.run([
  '$rootScope', '$location', '$auth', 'titleService',
  ($rootScope, $location, $auth, titleService)->

    $rootScope.$on('$routeChangeStart', (event, next)->
      if next.restricted
        promise = $auth.validateUser()
        promise.then(
          (valid)->
            # it's ok, ignore
          , 
          (error)->
            console.log "User validation error. Reason: #{error.reason}"
            $location.path('/users/login') unless $auth.user.admin
        )
    )

    titleService.init()
])