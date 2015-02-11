angular.module('receta').controller('ModalTagsController', ['$scope', 'Tag', ($scope, Tag)->
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