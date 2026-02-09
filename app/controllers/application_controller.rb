class ApplicationController < ActionController::Base
  # Ensure Pundit is included in the correct controller.
  include Pundit::Authorization
  # Rescue from Pundit errors and handle them.
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # Only allow modern browsers supporting webp images, web push, badges,
  # import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # Devise: Ensure users are authenticated before accessing certain actions.
  before_action :authenticate_user!

  def record_not_found_raise_404!
    raise ActiveRecord::RecordNotFound.new("Not Found")
  end

  protected

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to root_path
  end
end
