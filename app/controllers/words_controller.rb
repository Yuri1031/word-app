class WordsController < ApplicationController
  before_action only: [:create, :update] do
    resize_before_save(params[:word][:image], 1200, 1200)
  end
  before_action :set_from_study_flag, only: [:show, :update]

  def show
    @word = Word.find(params[:id])
    @category = @word.category
    @back_path = session[:previous_page]
    @groups = (current_user.groups + current_user.owned_groups).uniq
    @from_study = ActiveModel::Type::Boolean.new.cast(params[:from_study])
  
    word_mark = @word.word_marks.find_by(user_id: current_user.id)
    if word_mark && word_mark.mark_type.present?
      word_mark.update(mark_type: nil)
    end
  
    words_in_category = @category.words.order(:id)
    current_index = words_in_category.index(@word)
    @next_word = words_in_category[current_index + 1] || words_in_category.first
    @previous_word = current_index.zero? ? words_in_category.last : words_in_category[current_index - 1]
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
      @groups = (current_user.groups + current_user.owned_groups).uniq
  
      words_in_category = @category.words.order(:id)
      current_index = words_in_category.index(@word)
      @next_word = words_in_category[current_index + 1] || words_in_category.first
      @previous_word = current_index.zero? ? words_in_category.last : words_in_category[current_index - 1]
  
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
    @words = @category.words
                      .joins(:word_marks)
                      .where(word_marks: { user_id: current_user.id })
                      .where("word_marks.review_date IS NULL OR word_marks.review_date <= ?", Date.today)
                      .distinct
    
    if @words.empty?
      redirect_to category_path(@category), alert: "マークされた単語がありません。"
      return
    end

    @word = @words.find_by(id: params[:id]) || @words.first
    @back_path = session[:previous_page]

    word_index = @words.index(@word)
    @previous_word = word_index.positive? ? @words[word_index - 1] : nil
    @next_word = (word_index < @words.size - 1) ? @words[word_index + 1] : nil
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

  def set_from_study_flag
  @from_study = params[:from_study].to_s == "true"
end



  private
  def word_params
    params.require(:word).permit(:title, :question, :answer, :uploaded_image)
  end

  def resize_before_save(image_param, width, height)
    return unless image_param.respond_to?(:tempfile)
    ImageProcessing::MiniMagick
      .source(image_param.tempfile)
      .resize_to_limit(width, height)
      .call(destination: image_param.tempfile.path)
  rescue StandardError
  end


end
