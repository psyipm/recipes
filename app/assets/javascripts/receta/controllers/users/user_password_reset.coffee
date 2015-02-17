angular.module('receta').controller('UserPasswordResetController', 
  ['$scope', '$auth', '$location', '$timeout',
  ($scope, $auth, $location, $timeout)->
    $scope.alerts = []

    $scope.resetPasswd = ()->
      $scope.alerts = []
      $scope.waiting = true
      $auth.requestPasswordReset($scope.passwordResetForm)
        .then((resp)->
          $scope.waiting = false
          $scope.alerts.push {type: "success", msg: "Письмо с дальнейшими инструкциями отправлено на #{resp.config.data.email}"}
        )
        .catch((resp)->
          $scope.waiting = false
          $scope.alerts.push {type: "danger", msg: "Произошла ошибка. Пожалуйста, попробуйте позже"}
        )

    if $location.hash().indexOf("reset_password=true") != -1
      hash = $location.hash().replace("?client_id", "client_id")

      params = hash.split("&")
      search = {}
      for param in params
        key = param.split("=")
        search[key[0]] = key[1]
      
      $location.search(search)

    $scope.$on('$locationChangeSuccess', ()->
      if $location.search().token != undefined
        $auth.dfd = null
        $timeout((-> $auth.validateUser()), 0)
    )
    
    $scope.$on('auth:password-reset-confirm-success', ()->
      $location.path("/users/update-password")
    )
])