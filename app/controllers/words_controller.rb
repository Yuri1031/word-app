class WordsController < ApplicationController
  
  def show
    @word = Word.find(params[:id])
    @category = @word.category
    @back_path = session[:previous_page]

    # >
    words_in_category = @category.words.order(:id)
    current_index = words_in_category.index(@word)
    @next_word = words_in_category[current_index + 1] || words_in_category.first

    # <
    @previous_word = if current_index.zero?
                       words_in_category.last
                      else
                       words_in_category[current_index - 1]
                      end
  end

  def new
    @category = Category.find(params[:category_id])
    @word = @category.words.new
  end

  def create
    @category = Category.find(params[:category_id])
    @word = @category.words.new(word_params)  # @categoryに関連する新しい単語を作成
  
    @word.user_id = current_user.id
    
    if @word.save
      redirect_to category_path(@category)
    else
      render :new, status: :unprocessable_entity
    end
  end  

  def edit
    @category = Category.find(params[:category_id])
    @word = @category.words.find(params[:id])
  end

  def update
    @category = Category.find(params[:category_id])
    @word = @category.words.find(params[:id])
    if @word.update(word_params)
      redirect_to category_word_path(@category, @word), notice: "Data has been edited!"
      else
        render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:category_id])
    @word = @category.words.find(params[:id])
    @word.destroy
    redirect_to category_path(@category), notice: "Data has been deleted!"
  end


  private
  def word_params
    params.require(:word).permit(:title, :question, :answer)
  end


end
