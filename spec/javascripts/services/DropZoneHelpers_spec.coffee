describe "DropZoneHelpers", ->
	dz = null
	beforeEach(->
		module "receta"
		module "recetaServices"
		inject(($injector)->
			dz = $injector.get "DropZoneHelpers"
		)
		dz.init()
		dz.photos = [1,2,3,4]
	)

	describe "deleteFileById", ->
		it "should delete file from array", ->
			dz.deleteFileById(2)
			expect(dz.photos).not.toContain(2)

		it "should delete only one file", ->
			dz.deleteFileById 2
			expect(dz.getPhotos()).toEqualData([1,3,4])

	describe "getPhotos", ->
		it "should return photos array by default", ->
			expect(dz.getPhotos()).toEqualData([1,2,3,4])

		it "should return photos array as string if specified", ->
			expect(dz.getPhotos(true)).toEqualData([1,2,3,4].join(", "))

	describe "appendFile", ->
		it "should append id to the array", ->
			dz.appendFile 8
			expect(dz.getPhotos()).toContain 8

		it "should not add existent ids", ->
			dz.appendFile 8
			dz.appendFile 8
			expect(dz.getPhotos()).toEqualData [1,2,3,4,8]