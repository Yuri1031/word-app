# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      store_location_for(resource, new_user_registration_path)
      flash[:error_messages] = resource.errors.full_messages
      redirect_to new_user_registration_path
    end
  end

  def sign_up_params
    params.require(:user).permit(:name, :nickname, :profile_picture, :color_id, :email, :password, :password_confirmation)
  end
  
  def after_new_user_session_path_for(resource)
    categories_path
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
  
  def after_update_path_for(resource)
    mypage_path
  end

  
end
