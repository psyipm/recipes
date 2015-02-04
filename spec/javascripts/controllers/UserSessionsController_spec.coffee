describe "UserSessionsController", ->
  scope        = null
  ctrl         = null
  location     = null
  rootScope    = null

  setupController =(keywords)->
    inject(($rootScope, $controller, $location)->
      rootScope   = $rootScope
      scope       = $rootScope.$new()
      location    = $location

      ctrl        = $controller("UserSessionsController",
                                $scope: scope
                                $location: location
                                )

      location.path('/users/login')
    )

  beforeEach(module("receta"))
  beforeEach(setupController())

  describe "initialization", ->
    it "should have no alerts", ->
      expect(scope.alerts).toEqual([])

  describe "login success", ->
    beforeEach ->
      rootScope.$broadcast('auth:login-success')

    it "should redirect to /", ->
      expect(location.path()).toEqual('/')

  describe "login error", ->
    beforeEach ->
      rootScope.$broadcast('auth:login-error', { reason: 'unauthorized', errors: ['error message'] })

    it "should display message", ->
      expect(scope.alerts).toEqualData([{ type : 'danger', msg : 'error message' }])

    it "should not change location", ->
      expect(location.path()).toEqual('/users/login')

