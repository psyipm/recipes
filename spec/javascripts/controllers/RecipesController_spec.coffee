describe "RecipesController", ->
  scope        = null
  ctrl         = null
  location     = null
  routeParams  = null
  resource     = null

  setupController =(keywords)->
    inject(($rootScope, $resource, $controller, $httpBackend, $location)->
      scope       = $rootScope.$new()
      resource    = $resource
      httpBackend = $httpBackend 
      location    = $location

      ctrl        = $controller("RecipesController",
                                $scope: scope
                                $location: location)

      afterEach ->
        httpBackend.verifyNoOutstandingExpectation()
        httpBackend.verifyNoOutstandingRequest()
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