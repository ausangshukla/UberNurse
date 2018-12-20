class ShiftsController < ApplicationController
  
  before_action :authenticate_user!, :except => [:reject_anonymously]

  load_and_authorize_resource param_method: :shift_params, :except => [:reject_anonymously]

  # GET /shifts
  def index

    @shifts = Shift.where(care_home_id: current_user.care_home_ids) if current_user.care_home_id && !@shifts

    if (params[:staffing_request_id].present?)
        @shifts = @shifts.where(staffing_request_id: params[:staffing_request_id])
    end

    if(params[:response_status].present?)
      @shifts = @shifts.where(response_status: params[:response_status])
    else
      @shifts = @shifts.open
    end

    @per_page = 100
    @shifts = @shifts.joins(:staffing_request).order("staffing_requests.start_date asc").page(@page).per(@per_page)
    render json: @shifts.includes(:staffing_request, :care_home, :user=>:profile_pic), include: "user,care_home", each_serializer: ShiftMiniSerializer

  end

  # GET /shifts/1
  def show

    if(current_user.id == @shift.user_id && !@shift.viewed)
      # Mark this as viewed if the care giver assigned, has seen it
      @shift.viewed = true 
      @shift.save
    end
    
    render json: @shift
  end

  # POST /shifts
  def create
    @shift = Shift.new(shift_params)
    @shift.user_id = current_user.id

    if @shift.save
      render json: @shift, status: :created, location: @shift
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shifts/1
  def update
    if @shift.update(shift_params)
      render json: @shift
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shifts/1
  def destroy
    @shift.response_status = "Cancelled"
    @shift.save
  end

  def reject_anonymously
    @shift = Shift.find(params[:id])
    if (params[:hash] == @shift.generate_anonymous_reject_hash)
      @shift.response_status = "Rejected"
      @shift.save
      redirect_to "http://blog.connuct.co.uk/unsubscribe?rejected=true"
    else
      redirect_to "http://blog.connuct.co.uk/unsubscribe?rejected=failed"
    end
  end

  def start_end_shift
    @shift = Shift.find(params[:id])

    qr_code = params[:qr_code]
    # Compare the qr code sent by the app to that in the care home db
    if(@shift.user_id == current_user.id && @shift.care_home.qr_code == qr_code)
      
      if(@shift.start_code == nil)
        # Start the shift
        @shift.start_code = @shift.staffing_request.start_code
      else
        # End the shift
        @shift.end_code = @shift.staffing_request.end_code
      end
        
      if @shift.save
        render json: @shift
      else
        render json: @shift.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "Invalid QR Code"}, status: :unprocessable_entity
    end

  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shift
      @shift = Shift.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def shift_params
      params.require(:shift).permit(:staffing_request_id, :user_id, :start_code, 
        :end_code, :response_status, :accepted, :rated, :care_home_id, :payment_status)
    end
end
