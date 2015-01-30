angular.module('receta').controller("UserRegistrationsController", ['$scope', '$location', '$auth',
  ($scope,$location,$auth)->
    $scope.handleRegBtnClick = ()->
      $auth.submitRegistration($scope.registrationForm)
        .then ()->
          $auth.submitLogin(
            email: $scope.registrationForm.email,
            password: $scope.registrationForm.password
          )
])