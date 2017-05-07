class RatingsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :rating_params

  # GET /ratings
  def index
    @ratings = @ratings.includes(:user, :hospital)
    render json: @ratings
  end

  # GET /ratings/1
  def show
    render json: @rating
  end

  # POST /ratings
  def create
    @rating = Rating.new(rating_params)
    @rating.created_by_id = current_user.id
    @rating.hospital_id = current_user.hospital_id

    if @rating.save
      render json: @rating, status: :created, location: @rating
    else
      render json: @rating.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ratings/1
  def update
    if @rating.update(rating_params)
      render json: @rating
    else
      render json: @rating.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ratings/1
  def destroy
    @rating.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rating
      @rating = Rating.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def rating_params
      params.require(:rating).permit(:user_id, :staffing_response_id, :stars, :comments)
    end
end
