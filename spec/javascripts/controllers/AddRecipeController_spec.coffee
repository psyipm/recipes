text = "Запеканка из фарша с начинкой и в картофельной «шубке»

  Ингредиенты:

  750-1000 г. фарш ( свинина + говядина )
  2 средние луковицы
  2 яйца
  1 красный болгарский перец
  200 г. сыра «Фета»
  200 г белого хлеба
  1 большой кабачок или цуккини ( 300 г.)
  5-6 средних шт. картофель
  2 ч. ложки горчицы
  соль
  перец
  тимьян

  Приготовление:

  Белый хлеб замочить в холодной воде.
  Лук почистить и порезать очень мелко кубиками.
  Болгарский перец и « фету » порезать мелкими кубиками.
  Цуккини вымыть, нарезать вдоль ( лучше всего специальным ножом для чистки овощей ) тонкими полосками и обжарить 5 минут в горячем растительном масле.

  К фаршу добавить яйца, отжатый белый хлеб, лук, горчицу, соль, перец, тимьян и хорошо вымешать. Затем добавить болгарский перец и « Фету » и ещё раз перемешать.
  Разделить фарш на 2 равные части.
  Форму для запекания застелить пекарской бумагой. 

  Выложить половину фарша на бумагу, придавая ей овальную продолговатую форму. Сверху выложить обжаренные цуккини и накрыть второй половиной фарша, сглаживая все стороны
  Картофель почистить, потереть на крупной тёрке, посолить, отжать и выложить на фарш, чуть придавливая сверху и по бокам.

  Запекать в предварительно разогретой до 200 °C духовке на среднем уровне примерно 1 час (или полтора часа — зависит от Вашей духовки )"

dict = ["креветки","картофель","морковь","авокадо","яйца","сметана","майонез","лимон","яйца куриные","сыр твердый","фрикадельки"]

describe "AddRecipeController", ->
  scope        = null
  ctrl         = null
  resource     = null

  setupController =(keywords)->
    inject(($rootScope, $resource, $controller, $httpBackend)->
      scope       = $rootScope.$new()
      resource    = $resource

      httpBackend = $httpBackend 

      ctrl        = $controller("AddRecipeController",
                                $scope: scope
                                $location: location)

      afterEach ->
        httpBackend.verifyNoOutstandingExpectation()
        httpBackend.verifyNoOutstandingRequest()

      scope.dictionary = dict
      scope.text = text
    )

  beforeEach(module("receta"))
  beforeEach(setupController())

  describe "textChanged", ->
    it "should be defined", ->
      expect(typeof scope.textChanged).toEqual("function")

    it "should parse text", ->
      scope.textChanged()
      expect(scope.components).toEqualData(["картофель", "яйца"])

  describe "addComponent", ->
    beforeEach ->
      scope.textChanged()

    it "should handle empty strings", ->
      try
        scope.addComponent()
      catch e
        expect(e).toEqual("we shouldn't be there")

    it "should add lowercased component to list", ->
      scope.addComponent("Сыр")
      expect(scope.components).toEqualData(['сыр', 'картофель', 'яйца'])

    it "should remove any duplicates from list", ->
      scope.addComponent("картофель")
      scope.addComponent("КартОФЕЛЬ")
      expect(scope.components).toEqualData(['картофель', 'яйца'])

  describe "removeComponent", ->
    beforeEach ->
      scope.textChanged()

    it "should be defined", ->
      expect(typeof scope.removeComponent).toEqual("function")

    it "should push removed component to array", ->
      scope.removeComponent("картофель")
      expect(scope.user_removed).toContain("картофель")
