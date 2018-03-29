module Admin
  class StaffingRequestsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index
      if params[:search].present?
        search(StaffingRequest)
      else
        super
        @resources = StaffingRequest.page(params[:page]).per(10)
      end
    end

    def find_care_givers
      @staffing_request = StaffingRequest.find(params[:id])
      @users = @staffing_request.find_care_givers(params[:max_distance].to_i)      
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   StaffingRequest.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
