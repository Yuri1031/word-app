class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_categories, only: [:index, :create, :show]

  def index
    @category = Category.new
  end

  def show
    session[:previous_page] = request.fullpath
    @category = Category.find(params[:id])
    @words = @category.words
  end

  def new
  end

  def create
    @category = current_user&.categories&.build(category_params) || Category.new(category_params)
    @category.user ||= current_user
  
    if @category.save
      redirect_to categories_path, notice: "カテゴリを作成しました！"
    else
      @categories = current_user.categories
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path, notice: "Data has been deleted!"
  end
  

  private
  def category_params
    params.require(:category).permit(:category_name, :category_img)
  end
  
  def set_categories
    @categories = current_user.categories
  end

end
