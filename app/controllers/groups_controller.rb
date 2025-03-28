class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end
  
  def show
    @group = Group.find(params[:id])
    @group_words = @group.group_words.includes(:word)
  end

  def new
    @group = Group.new
    @users = User.all 
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      user_ids = params[:group][:user_ids] || []
      user_ids.each do |user_id|
        @group.group_members.create(user_id: user_id)
      end
      redirect_to @group, notice: 'グループが作成されました'
     else
      render :new
    end
  end

  private
  def group_params
    params.require(:group).permit(:group_name, :group_img, user_ids: [])
  end
end
