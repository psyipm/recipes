angular.module('receta').directive('recipeTags', ()->
  restrict: "E"
  scope: {
    recipe: "="
    tags: "="
  }
  templateUrl: 'tags/recipe_tags.html'
  controller: ['$scope', '$modal', 'Tag', ($scope, $modal, Tag)->
    $scope.showLink = ()->
      $(".all-tags").fadeIn()
    $scope.hideLink = ()->
      $(".all-tags").fadeOut()

    $scope.openModal = ()->
      $scope.modalInstance = $modal.open({
        templateUrl: 'tags/modal_recipe_tags.html'
        scope: $scope
        controller: 'ModalTagsController'
      })

    $scope.ok = ()->
      $scope.modalInstance.close()
      Tag.for_recipe $scope.recipe.id, ((tags)-> $scope.tags = tags), 5
  ]
  link: (scope, element)->
    element.bind("mouseenter", ()->
      scope.showLink()
    )
    element.bind("mouseleave", ()->
      scope.hideLink()
    )
)