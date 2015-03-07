Array::unique = ->
    output = {}
    output[@[key]] = @[key] for key in [0...@length]
    value for key, value of output

angular.module('receta').controller("RecipesController", [
  '$scope','$location','$routeParams','TokenfieldHelpers','Component','RecipeService', 
  ($scope,$location,$routeParams,tf,Component,RecipeService)->
    $scope.tfCallback = (request, response)->
      Component.find(request.term, (c)-> response(c))

    $scope.tokenhelpers = tf.bind "keywords-inp"
    $scope.tokenhelpers.init $scope.tfCallback

    $(".keyword-ex-lnk").on("click", ()-> $scope.tokenhelpers.addToken $(this).text())

    $scope.clearParams = ()->
      $scope.tokenhelpers.setTokens []; return

    $scope.recipes = []
    $scope.offset = 0

    buildQuery = ()->
      query = {}
      if $routeParams.hasOwnProperty "components"
        $scope.tokenhelpers.setTokens $routeParams.components
        query = $.extend true, query, {tokens: $scope.tokenhelpers.getTokens()}
      if $routeParams.hasOwnProperty "tags"
        query = $.extend true, query, {tags: $routeParams.tags.split(",")}
      query

    pushRecipes = (recipes, replace = false)->
      $scope.recipes = unless replace is true then recipes else [].concat($scope.recipes, recipes)

      tokens = $scope.tokenhelpers.getTokens()
      unless tokens.join(",").length > 0 
        return

      $("title").text("Рецепты с ингредиентами: #{tokens.join(", ")} - Recipes4You")

      for r in $scope.recipes
        for t in tokens
          r.recipe.text = r.recipe.text.replace(new RegExp(t, 'ig'), "<strong>#{t}</strong>") if r and r.recipe and r.recipe.text
          continue
        continue

    searchCallback = (recipes, replace = false)->
      $scope.no_more = false
      pushRecipes(recipes, replace)
      unless recipes.length < RecipeService.per_page
        $scope.offset += RecipeService.per_page
      else
        $scope.no_more = true
      $("#more").attr("disabled", $scope.no_more)

    $scope.search = (load_more = false)->
      try
        tokens = $scope.tokenhelpers.getTokens()
        $location.search("components", tokens.join(","))
        RecipeService.find(buildQuery(), $scope.offset).then((res)-> searchCallback res, load_more) if load_more is true
      catch e
        console.log e   

    $scope.searchFromLocation = ()->
      query = buildQuery()
      RecipeService.find(query, $scope.offset).then((res)-> searchCallback res) unless $.isEmptyObject query

    # $(".fotorama").fotorama()

    $scope.searchFromLocation()
])
.run([
  '$timeout', '$location',
  ($timeout, $location)->
    $timeout(
      ()-> $location.search("components", "")
    , 1000)
])