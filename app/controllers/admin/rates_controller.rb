module Admin
  class RatesController < Admin::ApplicationController
    
    def index

      if params[:search].present?
        search(Shift)
      else
        resources, search_term = setup_index(params)
        resources = resources.includes(:care_home, :agency)

        page = Administrate::Page::Collection.new(dashboard, order: order)

        render locals: {
          resources: resources,
          search_term: search_term,
          page: page,
          show_search_bar: show_search_bar?,
        }

      end
    end

    def create
      resource = resource_class.new(resource_params)
      # Ensure agency_id is set
      resource.agency_id = current_user.agency_id
      authorize_resource(resource)

      if resource.save
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end
    
  end
end
