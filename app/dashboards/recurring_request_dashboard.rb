require "administrate/base_dashboard"

class RecurringRequestDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    care_home: BelongsToOrderedField,
    staffing_requests: Field::HasMany,
    user: Field::BelongsToSearch,
    agency: Field::BelongsTo,
    user_id: Field::Number,
    preferred_carer_id: Field::Number,
    preferred_carer: Field::BelongsToSearch.with_options(class_name: "User"),
    id: Field::Number,
    start_date: Field::DateTime,
    end_date: Field::DateTime,
    role: Field::Select.with_options(collection: User::ROLE), 
    speciality: Field::Select.with_options(collection: User::SPECIALITY),    
    audit: HashField,
    dates: ArrayField,
    notes: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :agency,    
    :care_home,
    :user,
    :role,
    :speciality,
    :dates
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :agency,    
    :care_home,
    :user,
    :id,
    :start_date,
    :end_date,
    :role,
    :speciality,
    :created_at,
    :updated_at,
    :staffing_requests,
    :dates,
    :notes,
    :audit
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :care_home,
    :user,
    :preferred_carer,
    :start_date,
    :end_date,
    :dates,
    :role,
    :speciality,
    :notes,
  ].freeze

  # Overwrite this method to customize how recurring requests are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(recurring_request)
  #   "RecurringRequest ##{recurring_request.id}"
  # end
end
