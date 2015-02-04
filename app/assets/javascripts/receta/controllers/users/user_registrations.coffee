angular.module('receta').controller("UserRegistrationsController", ['$scope', '$location', '$auth'
  ($scope,$location,$auth)->
    $scope.alerts = []

    $scope.handleRegBtnClick = ()->
      $scope.waiting = true
      $scope.alerts = []
      $auth.submitRegistration($scope.registrationForm)
    
    $scope.$on('auth:registration-email-success', (ev, message)->
      $scope.alerts.push {type: 'success', msg: "Письмо с дальнейшими инструкциями отправлено на #{message.email}"}
      $scope.waiting = false
    )

    $scope.$on('auth:registration-email-error', (ev, reason)->
      for m in reason.errors.full_messages
        $scope.alerts.push {type: 'danger', msg: "#{m}"}

      $scope.waiting = false
    )

    if $location.hash()
      hash = $location.hash()
      $location.path('/users/login').hash("") if hash.indexOf "confirmation_success=true" != -1
])