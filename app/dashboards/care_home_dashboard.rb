require "administrate/base_dashboard"

class CareHomeDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    limit_shift_to_pref_carer: Field::Boolean,
    verified: Field::Boolean,
    manual_assignment_flag: Field::Boolean,
    zone: Field::Select.with_options(collection: CareHome::ZONES),
    users: Field::HasMany,
    staffing_requests: Field::HasMany.with_options(limit: 10, sort_by: :start_date),
    name: Field::String,
    speciality: Field::Select.with_options(collection: User::SPECIALITY),
    phone: Field::String,
    address: Field::String.with_options(required: true),
    town: Field::String.with_options(required: true),
    postcode: Field::String.with_options(required: true),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    image_url: Field::Text,
    care_home_broadcast_group: Field::String,
    sister_care_homes: Field::String,
    qr_code: QrCodeField,
    preferred_care_giver_ids: Field::String,
    lat: Field::String.with_options(searchable: false),
    lng: Field::String.with_options(searchable: false),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :speciality,
    :sister_care_homes,
    :care_home_broadcast_group,
    :town,
    :verified,
    :manual_assignment_flag,
    :zone
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :qr_code,
    :speciality,
    :phone,
    :verified,
    :manual_assignment_flag,
    :zone,
    :limit_shift_to_pref_carer,
    :sister_care_homes,
    :care_home_broadcast_group,
    :preferred_care_giver_ids,
    :address,
    :town,
    :postcode,
    :created_at,
    :updated_at,
    :image_url,
    :lat,
    :lng,
    :users,
    :staffing_requests,

  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :speciality,
    :phone,
    :sister_care_homes,
    :care_home_broadcast_group,
    :preferred_care_giver_ids,
    :address,
    :town,
    :postcode,
    :image_url,
    :verified,
    :manual_assignment_flag,
    :zone,
    :qr_code,
    :limit_shift_to_pref_carer
  ].freeze

  # Overwrite this method to customize how care_homes are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(care_home)
    "#{care_home.name} #{care_home.id}"
  end
end
