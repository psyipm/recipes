angular.module('receta').controller('RecipeUserRatingController', ['$scope', 'Rating', ($scope, Rating)->

  updateRating = ()->
    _liked = $scope.recipe.rating
    _disliked = $scope.recipe.dislikes || 0

    n = if _liked > 0 then (_liked + _disliked) / _liked else 100

    $scope.liked =  100 / n
    $scope.disliked = 100 - $scope.liked

  updateRating()

  $scope.setUserRate = (rate)->
    selector = "#recipe-#{$scope.recipe.id}-rating"
    if parseInt(rate) > 0
      $(selector).find(".rating-like").addClass("rulez")
      $(selector).find(".rating-dislike").removeClass("sux")
      return
    if parseInt(rate) < 0
      $(selector).find(".rating-dislike").addClass("sux")
      $(selector).find(".rating-like").removeClass("rulez")
      return

  $scope.like = ()->
    if Rating.like($scope.recipe.id)
      $scope.recipe.rating++
      $scope.recipe.dislikes-- if $scope.recipe.dislikes > 0
      $scope.setUserRate(1)
      updateRating()

  $scope.dislike = ()->
    if Rating.dislike($scope.recipe.id)
      $scope.recipe.rating-- if $scope.recipe.rating > 0
      $scope.recipe.dislikes++
      $scope.setUserRate(-1)
      updateRating()
])