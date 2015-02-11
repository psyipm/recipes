class TagsController < ApplicationController
  def find
    query = params[:query]
    @tags = Tag.select('distinct lower(title) as title').where('lower(title) like ?', "%#{query.mb_chars.downcase}%")
  end

  def cloud
    @tags = Tag.cloud
  end

  def for_recipe
    @tags = Tag.for_recipe params[:recipe_id], params[:limit], params[:sort]
  end

  def create
    @tag = Tag.new tag_params
    begin
      @tag.save
      render json: { success: 1, tag: @tag }, status: 200
    rescue Exception => e
      render json: { error: "unable to save tag", message: e.message }, status: 401
    end
  end

  private
  def tag_params
    params.require(:tag).permit(:title, :recipe_id)
  end
end
