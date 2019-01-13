# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_user!
    before_action :check_admin

    def check_admin
      ok = current_user && (current_user.role == "Super User" || current_user.role == "Agency")
      if ok
        logger.debug "check_admin called with #{current_user.id}"      
        return true
      else
        if current_user 
          raise CanCan::AccessDenied 
        else
          return false
        end
      end
    end

    def scoped_resource
      super.accessible_by(current_ability) if current_user.role == "Agency"
    end

    # Hide links to actions if the user is not allowed to do them      
    def show_action?(action, resource)
      Ability.new(current_user).can? action, resource
    end

    # Raise an exception if the user is not permitted to access this resource
    def authorize_resource(resource)
      raise CanCan::AccessDenied unless show_action?(params[:action], resource)
    end

    before_action :default_params

    def default_params
      params[:order] ||= 'id'
      params[:direction] ||= 'desc'
    end
    
    before_action :set_paper_trail_whodunnit

    def set_paper_trail_whodunnit
      PaperTrail.request.whodunnit = current_user.id if current_user
    end

    
    def setup_search
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: @resources,
        search_term: params[:search],
        page: page,
        show_search_bar: true
      }
    end

    def show_search_bar?
      true
    end
    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end

    def search(entity)
      with = params[:with].present? ? eval("{"+params[:with].gsub(/ ?= ?/,":")+"}") : {}
      if params[:search] == "*"
        @resources = entity.search( with: with ).page(params[:page]).per(10)
      else
        @resources = entity.search( params[:search], with: with ).page(params[:page]).per(10)
      end
      setup_search
    end


    rescue_from CanCan::AccessDenied do |exception|
      flash[:notice] = "Access Denied"
      redirect_to admin_root_path
    end
  end
end
