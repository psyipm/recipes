angular.module('receta').directive('recipeTags', ()->
  restrict: "E"
  scope: {
    recipe: "="
    tags: "="
  }
  templateUrl: 'recipes/recipe_tags/recipe_tags.html'
  controller: ['$scope', '$modal', ($scope, $modal)->
    $scope.showLink = ()->
      $(".all-tags").fadeIn()
    $scope.hideLink = ()->
      $(".all-tags").fadeOut()

    $scope.openModal = ()->
      $scope.modalInstance = $modal.open({
        templateUrl: 'recipes/recipe_tags/all_tags.html'
        scope: $scope,
        controller: ['Tag', 'TokenfieldHelpers', (Tag, tf)->
          Tag.for_recipe($scope.recipe.id, (tags)-> $scope.tags = tags)

          tfCallback = (request, response) ->
            Tag.find request.term, (t)-> response(t)

          $scope.tfHelpers = tf.bind "newtag"
          $scope.tfHelpers.init tfCallback
        ]
      })

    $scope.editing = false
    $scope.newTag = ()->
      $scope.editing = !$scope.editing

    $scope.ok = ()->
      $scope.modalInstance.close()
  ]
  link: (scope, element)->
    element.bind("mouseenter", ()->
      scope.showLink()
    )
    element.bind("mouseleave", ()->
      scope.hideLink()
    )
)