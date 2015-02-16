angular.module('receta').controller('UserPasswordUpdateController', 
  ['$scope', '$auth',
  ($scope, $auth)->
    $scope.alerts = []

    fields = {
      password: "Пароль"
      password_confirmation: "Подтверждение пароля"
    }

    $scope.updatePassword = ()->
      $scope.alerts = []
      $scope.waiting = true
      $auth.updatePassword($scope.changePasswordForm)
        .then((resp)->
          $scope.waiting = false
          console.log resp
          $scope.alerts.push {type: "success", msg: "#{resp.data.data.message}"}
        )
        .catch((resp)->
          $scope.waiting = false
          for field, message of resp.data.errors
            $scope.alerts.push {type: "danger", msg: "#{fields[field]}: #{message}"}
            continue
        )
  ])