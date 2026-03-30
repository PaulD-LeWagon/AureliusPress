class AureliusPress::Api::V1::BaseController < AureliusPress::ApplicationController
  # Ensure all API requests are authenticated and authorized
  before_action :authenticate_user!
  before_action :authorize_admin_access

  respond_to :json

  private

  def authorize_admin_access
    # Use the same logic as the Admin namespace to ensure only moderators+ can access
    # internal taxonomy search APIs.
    unless AureliusPress::User.roles[current_user.role] >= AureliusPress::User.roles[:moderator]
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
