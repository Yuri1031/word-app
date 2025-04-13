class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user
  layout :layout_by_resource

  def show
    @user = current_user
    @categories = Category.all
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to mypage_path(@user), notice: "Data has been edited!"
    else
      render :show, status: :unprocessable_entity
    end
  end
  
  
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path  
  end

  private
  def set_user
    @user = current_user
  end
  
  def user_params
    params.require(:user).permit(:name, :nickname, :color_id, :profile_pic)
  end  

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :nickname, :color_id, :profile_pic, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :nickname, :color_id, :profile_pic, :email])
  end 

  def layout_by_resource
    if devise_controller?
      "devise"  
    else
      "application"  
    end
  end
  
end
