class StaffingRequestsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :staffing_request_params
  
  # GET /staffing_requests
  def index
     
    if(current_user.hospital_id.present?)
      # We need to show only the staffing requests of the hospital for employees, 
      @staffing_requests.where(hospital_id: current_user.hospital_id)
    else
      # but for Care givers show all in their geo location
    end
    render json: @staffing_requests.includes(:user, :hospital), include: "user,hospital"
  end

  # GET /staffing_requests/1
  def show
    render json: @staffing_request, include: "staffing_responses"
  end

  # POST /staffing_requests
  def create
    @staffing_request = StaffingRequest.new(staffing_request_params)
    @staffing_request.user_id = current_user.id
    @staffing_request.hospital_id = current_user.hospital_id
    if @staffing_request.save
      render json: @staffing_request, status: :created, location: @staffing_request
    else
      render json: @staffing_request.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /staffing_requests/1
  def update
    if @staffing_request.update(staffing_request_params)
      render json: @staffing_request
    else
      render json: @staffing_request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /staffing_requests/1
  def destroy
    @staffing_request.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staffing_request
      @staffing_request = StaffingRequest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def staffing_request_params
      params.require(:staffing_request).permit(:hospital_id, :user_id, :start_date, :end_date, :rate_per_hour, :request_status, :auto_deny_in, :response_count, :payment_status)
    end
end