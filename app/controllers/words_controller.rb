class WordsController < ApplicationController
  
  def show
    @word = Word.find(params[:id])
    @category = @word.category
    @back_path = session[:previous_page]
    @groups = (current_user.groups + current_user.owned_groups).uniq

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
    @word = @category.words.new(word_params) 
  
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

  def marked
    @category = Category.find(params[:category_id])
    @words = @category.words.joins(:word_marks).where(word_marks: { dif: 1 }).distinct
    @word = @words.find_by(id: params[:id]) || @words.first
    
    @back_path = session[:previous_page]

    if @word
      word_index = @words.index(@word)
      @previous_word = word_index.positive? ? @words[word_index - 1] : nil
      @next_word = (word_index < @words.size - 1) ? @words[word_index + 1] : nil
    end
  end

  def share
    @word = Word.find(params[:id])
    group_ids = params[:group_ids] || []
  
    # 現在の共有状態をリセット
    @word.group_words.where.not(group_id: group_ids).destroy_all
  
    # 新しい共有を作成（重複防止）
    group_ids.each do |gid|
      gw = GroupWord.find_or_initialize_by(group_id: gid, word_id: @word.id)
      gw.user_id = current_user.id
      gw.save!
    end
    
  
    redirect_to category_word_path(@word.category, @word), notice: "共有が完了しました。"
  end


  private
  def word_params
    params.require(:word).permit(:title, :question, :answer)
  end


end
