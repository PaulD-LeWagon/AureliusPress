class AureliusPress::ApplicationController < ::ApplicationController
  def authorize(record, query = nil, policy_class: nil)
    @_pundit_policy_authorized = true
    
    # If policy_class is provided, we use it. Otherwise we get the policy instance from Pundit.
    if policy_class
      @_pundit_policy = policy_class.new(pundit_user, record, params)
    else
      @_pundit_policy = policy(record)
      # Since we want to pass params to the policy, and it might not have been
      # initialized with them by the default Pundit helper, we'll re-initialize
      # if it's a model-level policy that hasn't seen the params yet.
      # However, to keep it simple and fix the error:
      @_pundit_policy = @_pundit_policy.class.new(pundit_user, record, params)
    end
    
    # Determine the query (e.g., :index?, :show?)
    # If not provided, we infer it from the record type.
    final_query = query
    if final_query.nil?
      if record.respond_to?(:each)
        final_query = :index?
      else
        final_query = :show?
      end
    end

    unless @_pundit_policy.send(final_query)
      raise Pundit::NotAuthorizedError, query: final_query, record: record, policy: @_pundit_policy
    end
    true
  end
end
