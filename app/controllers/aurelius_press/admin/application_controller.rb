class AureliusPress::Admin::ApplicationController < AureliusPress::ApplicationController
  # before_action :authorize_admin_access

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

  def pundit_policy_class(record)
    "AureliusPress::Admin::#{record.class.name.demodulize}Policy".constantize
  end

  private

  # Either use the `AureliusPress::Admin::UserPolicy` or override
  # ApplicationPolicy's constructor to  accept the params hash if you want to
  # use this to ensure only admins or above can access the admin namespace.
  def authorize_admin_access
    # Pass the class as the record for a controller-level check.
    # Pundit will use the current_user to perform the authorization.
    authorize AureliusPress::User, :admin_access?, policy_class: AureliusPress::Admin::ApplicationPolicy
  end
end
