class AureliusPress::Admin::ApplicationController < AureliusPress::ApplicationController
  # Ensure Pundit is included in the correct controller.
  include Pundit::Authorization
  # Rescue from Pundit errors and handle them.
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authorize_admin_access

  def authorize(record, query = nil, policy_class: nil)
    @_pundit_policy_authorized = true
    policy = policy_class || policy(record)

    # This passes the params to the policy constructor
    @_pundit_policy = policy.new(pundit_user, record, params)

    unless @_pundit_policy.send(query || pundit_policy_scope_query(record))
      raise Pundit::NotAuthorizedError, query: query, record: record, policy: @_pundit_policy
    end

    true
  end

  protected

  # pundit_user is what Pundit uses to get the user.
  # By default, this is an alias for current_user.

  def pundit_policy_class(record)
    "AureliusPress::Admin::#{record.class.name.demodulize}Policy".constantize
  end

  private

  def authorize_admin_access
    # Pass the class as the record for a controller-level check.
    # Pundit will use the current_user to perform the authorization.
    authorize AureliusPress::User, :admin_access?, policy_class: AureliusPress::Admin::ApplicationPolicy
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to root_path
  end
end
