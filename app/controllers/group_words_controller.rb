class GroupWordsController < ApplicationController
  def show 
    @group = Group.find(params[:group_id])
    @group_word = @group.group_words.find(params[:id])
    @word = @group_word.word
    @back_path = request.referer || group_path(@group)
  end
  def create
    @group = Group.find(params[:group_id])
    @word = Word.find(params[:word_id])
    @group_word = @group.group_words.build(word: @word, user: current_user)

    if @group_word.save
      redirect_to group_path(@group), notice: 'カードを追加しました'
     else
      redirect_to group_path(@group), alert: '追加に失敗しました'
    end
  end
end
