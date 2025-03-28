class WordsController < ApplicationController
  def show
    @word = Word.find(params[:id])
    @category = @word.category

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

  def create
    @word = Word.new(word_params)
    if @word.save
      redirect_to category_path(@word.category_id), notice: "タイトルを作成しました！"
    else
      render :index, status: :unprocessable_entity
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
        render :edit, status: :unprocessable_entity
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
