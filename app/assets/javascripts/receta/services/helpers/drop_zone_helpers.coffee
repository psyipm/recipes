angular.module('recetaServices').service('DropZoneHelpers', [
	()->
		class DropZoneHelpers
			constructor: ->
				@photos = []
				@instance = null

			init: ->
				try
					_self = this
					unless @instance == null
						@instance.destroy()

					@instance = new Dropzone(document.body, {
						url: "/photos", 
						previewsContainer: "#previews", 
						clickable: "#clickable",
						maxFilesize: 1,
						paramName: "upload[image]",
						addRemoveLinks: true,
						sending: (file, xhr, fd)-> _self.onSending.call _self, file, xhr, fd; return
						success: (f, r)-> _self.onSuccess.call _self, f, r; return
						removedfile: (f)-> _self.onRemove.call _self, f; return
					})

				catch ignore

			appendFile: (id)->
				@photos.push id if id not in @photos
				$("#photos").val(@getPhotos true); return

			deleteFileById: (id)->
				photos = []
				id = parseInt(id)
				$.map(@photos, (val)->
					val = parseInt(val)
					photos.push val if val != id
				)
				@photos = photos

				$("#photos").val(@getPhotos true); return

			getPhotos: (toString = false)->
				if toString
					@photos.join(", ")
				else
					@photos
		
			onSending: (file, xhr, formData)->
				formData.append "authenticity_token", $('meta[name=csrf-token]').attr('content')
				console.log formData
		
			onSuccess: (file, response)->
				$(file.previewTemplate).find(".dz-remove").attr("data-file-id", response.file.id)
				$(file.previewElement).addClass("dz-success")
				@appendFile response.file.id if response.hasOwnProperty "success"
		
			onRemove: (file)->
				id = $(file.previewTemplate).find(".dz-remove").attr("data-file-id")
				_self = this
				success = (data) ->
					$(file.previewTemplate).remove()
					_self.deleteFileById(id)
		
				$.ajax {type: "delete", url: "/photos/" + id, success: success}

		new DropZoneHelpers()
])