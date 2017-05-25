require "administrate/base_dashboard"

class StaffingRequestDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    care_home: Field::BelongsTo,
    user: Field::BelongsTo,
    staffing_responses: Field::HasMany,
    payment: Field::HasOne,
    id: Field::Number,
    start_date: Field::DateTime,
    end_date: Field::DateTime,
    role: Field::Select.with_options(collection: User::ROLE), 
    speciality: Field::Select.with_options(collection: User::SPECIALITY),
    price: Field::Number.with_options(decimals: 2),
    pricing_audit: Field::String, 
    request_status: Field::Select.with_options(collection: StaffingRequest::REQ_STATUS),
    auto_deny_in: Field::Number.with_options(decimals: 2),
    response_count: Field::Number,
    payment_status: Field::Select.with_options(collection: StaffingResponse::PAYMENT_STATUS),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    start_code: Field::String,
    end_code: Field::String,
    broadcast_status: Field::Select.with_options(collection: StaffingRequest::BROADCAST_STATUS),
    versions: VersionField
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :care_home,
    :user,
    :start_date,
    :end_date,
    :request_status,
    :payment_status,
    :price,
    :broadcast_status
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :care_home,
    :user,
    :staffing_responses,
    :payment,
    :id,
    :start_date,
    :end_date,
    :price,
    :pricing_audit,
    :request_status,
    :auto_deny_in,
    :response_count,
    :payment_status,
    :created_at,
    :updated_at,
    :start_code,
    :end_code,
    :broadcast_status
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :start_date,
    :end_date,
    :request_status,
    :auto_deny_in,
    :payment_status,
    :start_code,
    :end_code
  ].freeze

  # Overwrite this method to customize how staffing requests are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(staffing_request)
  #   "StaffingRequest ##{staffing_request.id}"
  # end
end