class AureliusPress::Admin::ApplicationController < AureliusPress::ApplicationController
  before_action :authorize_admin_access
  # =====================================================================
  # ARCHITECTURAL NOTE: :id vs :slug in Admin Controllers
  # 
  # This Admin namespace delegates internal objects (Users, Reactions, 
  # Comments) to standard integer `:id` lookups.
  # 
  # However, public SEO models (Pages, Authors, Categories) include the 
  # `Sluggable` module which overrides `to_param` to return their `.slug`. 
  # Because native Rails path helpers (like `edit_author_path(@author)`) 
  # globally generate URLs using `to_param`, the Admin interface natively 
  # receives `params[:id]` as a slug string for these models!
  # 
  # Therefore, specific admin controllers *must* use `find_by!(slug: params[:id])`
  # instead of `.find(params[:id])` to prevent ActiveRecord NotFound exceptions, 
  # whilst maintaining DRY path helper generated views.
  # =====================================================================

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
