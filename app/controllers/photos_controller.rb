class PhotosController < ApplicationController
  def new
    @upload = Photo.new
  end

  def create
    @upload = Photo.create(upload_params)
    if @upload.save
      render json: { 
              success: 1, 
              file: {
                id: @upload.id, 
                original: @upload.image.url, 
                medium: @upload.image.url(:medium), 
                thumb: @upload.image.url(:thumb)
              }
            }, :status => 200
    else
      #  you need to send an error header, otherwise Dropzone
      #  will not interpret the response as an error:
      render json: { error: @upload.errors.full_messages.join(', ')}, :status => 400      
    end
  end

  def destroy
    if current_user.try(:admin?)
      @upload = Photo.find_by id: params[:id]
    else
      @upload = Photo.find_by id: params[:id], recipe_id: nil
    end
    begin
      @upload.destroy
      render json: { success: 1, message: "File deleted from server" }, :status => 200
    rescue Exception => e
      render json: { error: 1, message: "Error while deleting file" }, :status => 400
    end
  end

  private
  def upload_params
    params.require(:upload).permit(:image)
  end
end
