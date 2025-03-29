# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
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
