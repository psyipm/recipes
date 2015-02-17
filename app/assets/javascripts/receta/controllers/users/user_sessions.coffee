angular.module('receta').controller("UserSessionsController", ['$scope', '$location', '$auth',
  ($scope,$location,$auth)->
    $scope.alerts = []

    $scope.$on('auth:login-error', (ev, reason)->
      $scope.alerts.push {type: 'danger', msg: reason.errors[0]}
    )

    $scope.$on('auth:login-success', ()->
      window.location.href = "/"
    )

    $scope.omniauthLogin = (provider)->
        $auth.authenticate(provider)
            .then((resp)->
                console.log resp
            )
            .catch((resp)->
                console.log resp
            )
])