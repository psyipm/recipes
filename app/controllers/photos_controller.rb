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
              file: {
                id: @upload.id, 
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
    @upload = Photo.find_by id: params[:id], recipe_id: nil
    begin
      @upload.destroy
      render json: { success: 1, message: "File deleted from server" }
    rescue Exception => e
      render json: { error: 1, message: "Error while deleting file" }
    end
  end

  private
  def upload_params
    params.require(:upload).permit(:image)
  end
end
