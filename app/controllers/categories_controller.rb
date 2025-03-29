class CategoriesController < ApplicationController
  before_action :set_categories, only: [:index, :create, :show]

  def index
    @category = Category.new
  end

  def show
    @category = Category.find(params[:id])
    @words = @category.words
  end

  def new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "カテゴリを作成しました！"
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path(@category), notice: "Data has been deleted!"
  end
  

  private
  def category_params
    params.require(:category).permit(:category_name, :category_img)
  end
  
  def set_categories
    @categories = Category.all
  end

end
