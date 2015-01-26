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

  describe "addTag", ->
    search = null
    beforeEach ()->
      scope.addTag("торт")
      scope.addTag("десерт")
      search = location.search()

    it "url should contain 'tags' key", ->
      expect(search.hasOwnProperty("tags")).toEqual(true)

    it "tags property should be a string", ->
      expect(typeof search.tags.split).toEqual("function")

    it "should add multiple tags delimited by comma to url", ->
      data = search.tags.split(",")
      expect(data).toContain("торт")
      expect(data).toContain("десерт")

  describe "clearTags", ->
    search = null
    beforeEach ()->
      scope.addTag("торт")
      scope.addTag("десерт")
      search = location.search()

    it "should remove all tags from search location", ->
      scope.clearTags()
      expect(location.search().hasOwnProperty("tags")).toEqual(false)
