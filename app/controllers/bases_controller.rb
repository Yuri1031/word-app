class BasesController < ApplicationController
  def index
    @categories = Category.all
  end
end
