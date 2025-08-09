class AureliusPress::ApplicationController < ::ApplicationController
  # Ensure Pundit is included in the correct controller.
  include Pundit::Authorization
  # Rescue from Pundit errors and handle them.
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to root_path
  end
end
