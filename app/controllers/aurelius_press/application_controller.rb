class AureliusPress::ApplicationController < ::ApplicationController
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
end
