# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    categories_path
  end

  def respond_to_on_destroy
    respond_to do |format|
      format.html { redirect_to new_user_session_path, notice: "Logged out successfully" }
      format.turbo_stream { head :see_other }
    end
  end
end
