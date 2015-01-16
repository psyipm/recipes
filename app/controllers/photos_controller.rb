class PhotosController < ApplicationController
  def new
    @upload = Photo.new
  end

  def create
    @upload = Photo.create(upload_params)
    if @upload.save
      styles = @upload.image.styles
      # send success header
      render json: { 
      				message: "success", 
      				id: @upload.id, 
      				url: { 
      					original: @upload.image.url, 
      					medium: styles[:medium].attachment.url, 
      					thumb: styles[:thumb].attachment.url
      				} 
      			}, :status => 200
    else
      #  you need to send an error header, otherwise Dropzone
      #  will not interpret the response as an error:
      render json: { error: @upload.errors.full_messages.join(', ')}, :status => 400
    end     
  end

  def destroy
    @upload = Photo.find(params[:id])
    if @upload.destroy    
      render json: { message: "File deleted from server" }
    else
      render json: { message: @upload.errors.full_messages.join(',') }
    end
  end

  private
  def upload_params
    params.require(:upload).permit(:image)
  end
end
