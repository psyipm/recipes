describe "RecipesController", ->
  scope        = null
  ctrl         = null
  location     = null
  routeParams  = null
  resource     = null

  setupController =(keywords)->
    inject(($rootScope, $resource, $controller, $httpBackend)->
      scope       = $rootScope.$new()
      resource    = $resource

      httpBackend = $httpBackend 

      ctrl        = $controller("RecipesController",
                                $scope: scope
                                $location: location)

      afterEach ->
        httpBackend.verifyNoOutstandingExpectation()
        httpBackend.verifyNoOutstandingRequest()
    )

  beforeEach(module("receta"))
  beforeEach(setupController())

  it "defaults to 1 recipes", ->
    expect(scope.recipes.length).toEqualData(1)

  describe "tokenfield helpers class", ->
    it "should be defined", ->
      expect(scope.tokenhelpers).toBeDefined()

    it "should be able to initialize", ->
      scope.tokenhelpers.init scope.tfCallback