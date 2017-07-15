require "application_responder"

class ApplicationController < ActionController::API
  
  # Devise stuff
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  # Authorization
  include CanCan::ControllerAdditions
  include ActionController::MimeResponds  
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
    end
  end

  # Required to enable additional user fields in registration
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :role, :nurse_type, 
        :sex, :title, :phone, :postcode, :languages, :pref_commute_distance, :speciality, :experience, 
        :referal_code, :accept_terms, :care_home_id, :password, :image_url, :verified, :sort_code, :bank_account])
  end
  # Exception handling via email notification
  before_action :prepare_exception_notifier
  private
  def prepare_exception_notifier
    if current_user
      request.env["exception_notifier.exception_data"] = {
        :current_user => current_user
      }
    end

    logger.debug "uid = #{request.headers['uid']}, access-token = #{request.headers['access-token']}, client = #{request.headers['client']}"
  end

  before_action :setup_pagination, only: [:index]

  def setup_pagination
    @page = params[:page].present? ? params[:page] : 1
    @per_page = params[:per_page].present? ? params[:per_page] : 10
    logger.debug("page=#{@page}, per_page=#{@per_page}")
  end
  
end
