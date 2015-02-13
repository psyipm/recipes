angular.module('recetaServices').service('DropZoneHelpers', [
  '$auth',
  ($auth)->

    _addFile = (file, response) ->
      file.upload =
        progress: 100
        total: file.size
        bytesSent: file.size
      @files.push file

      file.status = Dropzone.ADDED
      @emit "addedfile", file
      @_enqueueThumbnail file

      file.status = Dropzone.SUCCESS
      @emit "success", file, response

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
            success: (file, response)-> _self.onSuccess.call _self, file, response; return
            removedfile: (file)-> _self.onRemove.call _self, file; return
          })

        catch ignore

      addUploadedFile: (photo)->
        _self = this
        xhr = new XMLHttpRequest()
        xhr.open("GET", photo.thumb)
        xhr.responseType = "blob"
        xhr.onload = ()->
          _addFile.call _self.instance, xhr.response, { file: photo }

        xhr.send()

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

      removeAllFiles: ()->
        @photos = []
        @instance.removeAllFiles(true)
    
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