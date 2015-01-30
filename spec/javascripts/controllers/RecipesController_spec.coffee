describe "RecipesController", ->
  scope        = null
  ctrl         = null
  location     = null
  tf           = null
  component    = null
  recipe       = null

  setupController =(keywords)->
    inject(($rootScope, $controller, $location, TokenfieldHelpers, Component, Recipe)->
      scope       = $rootScope.$new()
      location    = $location
      tf          = TokenfieldHelpers
      component   = Component
      recipe      = Recipe

      ctrl        = $controller("RecipesController",
                                $scope: scope
                                $location: location
                                tf: tf
                                Component: component
                                Recipe: recipe)

      scope.tokenhelpers = tf.bind "keywords-inp"
      scope.tokenhelpers.init scope.tfCallback
    )

  beforeEach(module("receta"))
  beforeEach(setupController())

  it "recipes should be empty", ->
    expect(scope.recipes).toEqualData([])

  describe "tokenfield helpers class", ->
    it "should be defined", ->
      expect(scope.tokenhelpers).toBeDefined()

    it "should be able to initialize", ->
      scope.tokenhelpers.init scope.tfCallback

    it "should have own methods", ->
      expect(typeof scope.tokenhelpers.getTokens).toEqual("function")