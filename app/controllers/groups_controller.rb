class GroupsController < ApplicationController
  def index
    @groups = Group.all
    @group = Group.new
    #表示確認用 @users = User.all 
    @users = current_user.matchers
  end
  
  def show
    @group = Group.find(params[:id])
    @group_words = @group.group_words.includes(:word, :user)
    #表示確認用 @users = User.all
    @users = current_user.matchers

    @friends = current_user.matchers
  end

  def new
    @group = Group.new
    @users = User.all 
  end

  def create
    @group = Group.new(group_params)
    @groups = (current_user.groups + current_user.owned_groups).uniq

    if @group.save
      user_ids = params[:group][:user_ids] || []
      user_ids << current_user.id.to_s unless user_ids.include?(current_user.id.to_s)

      user_ids.each do |user_id|
        @group.group_members.create(user_id: user_id)
      end
      redirect_to @group, notice: 'グループが作成されました'
     else
      render :new
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      @group.group_members.destroy_all 
      (params[:group][:user_ids] || []).each do |user_id|
        @group.group_members.create(user_id: user_id)
      end
      redirect_to @group, notice: 'グループ情報を更新しました'
    else
      render :show, status: :unprocessable_entity
    end
  end
  

  private
  def group_params
    params.require(:group).permit(:group_name,:group_description, :group_img, user_ids: [])
  end
end
