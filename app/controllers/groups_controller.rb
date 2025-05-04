class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
    @group = Group.new
    @users = current_user.matchers
  end
  
  def show
    @group = Group.find(params[:id])
    @group_words = @group.group_words.includes(:word, :user)
    @users = (current_user.matchers + @group.users).uniq
    @friends = current_user.matchers
  end

  def new
    @group = Group.new
    @users = User.all 
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user 
    @groups = (current_user.groups + current_user.owned_groups).uniq

    if @group.save
      user_ids = ((params[:group][:user_ids] || []) + [current_user.id.to_s]).uniq.map(&:to_i)
      user_ids.each do |user_id|
        unless @group.group_members.exists?(user_id: user_id)
          @group.group_members.create(user_id: user_id)
        end
      end
      redirect_to @group, notice: 'グループが作成されました'
     else
      @groups = current_user.groups
      @users = current_user.matchers
      render :index, status: :unprocessable_entity
    end
  end

  def update
    @group = Group.find(params[:id])
    
    if @group.update(group_params)
      selected_user_ids = ((params[:group][:user_ids] || []) + [current_user.id.to_s]).uniq.map(&:to_i)
      current_user_ids = @group.group_members.pluck(:user_id)
  
      # 追加が必要なユーザー
      (selected_user_ids - current_user_ids).each do |user_id|
        @group.group_members.create(user_id: user_id)
      end
  
      # 削除が必要なユーザー
      (current_user_ids - selected_user_ids).each do |user_id|
        @group.group_members.find_by(user_id: user_id)&.destroy
      end
  
      redirect_to @group, notice: 'グループ情報を更新しました'
    else
      @group_words = @group.group_words.includes(:word, :user)
      @users = current_user.matchers
      @friends = current_user.matchers
      render :show, status: :unprocessable_entity
    end
  end

  def destroy_member
    @group = Group.find(params[:group_id])
    @user = User.find(params[:id])
  
    if @group.group_members.exists?(user_id: @user.id)
      @group.group_members.find_by(user_id: @user.id).destroy
  
      if @group.group_members.count == 0
        @group.destroy
        redirect_to groups_path, notice: 'グループは最後のメンバーが退会したため削除されました'
      else
        redirect_to groups_path, notice: 'グループから退会しました'
      end
    else
      redirect_to @group, alert: 'このグループには参加していません'
    end
  end

  private
  def group_params
    params.require(:group).permit(:group_name,:group_description, :group_img, user_ids: [])
  end
end
