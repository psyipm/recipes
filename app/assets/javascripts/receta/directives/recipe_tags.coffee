receta = angular.module('receta')
receta.directive('recipeTags', ()->
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
        scope: $scope
        controller: 'ModalTagsController'
      })
      console.log $scope

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

receta.controller('ModalTagsController', ['$scope', 'Tag', ($scope, Tag)->
  recipe_id = $scope.recipe.id
  Tag.for_recipe(recipe_id, (tags)-> $scope.tags = tags)

  $scope.addTag =()->
    title = $("#newtag").val()
    if title.length
      Tag.create title, recipe_id, (data)-> $scope.tags.push data
      $("#newtag").val(""); return
    else
      $scope.popoverMessage = "Тег не может быть пустым"
      $("#newtag").popover('show'); return

  $scope.editing = false
  $scope.newTag = ()->
    $scope.editing = !$scope.editing
    $("#newtag").val(""); return
])