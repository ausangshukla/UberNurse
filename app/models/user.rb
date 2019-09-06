class User < ApplicationRecord

  after_save :index_user
  has_paper_trail ignore: [:sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :tokens]

  validates_presence_of :first_name, :last_name, :email, :role, :phone

  belongs_to :care_home, optional: true
  has_many :profiles
  has_many :staffing_requests
  has_many :agency_user_mappings, dependent: :destroy
  has_many :agencies, :through => :agency_user_mappings
  has_many :shifts
  has_many :payments
  has_many :user_docs, -> { order(:verified=>:desc) }, dependent: :destroy
  has_one :profile_pic, -> { where(doc_type: "Profile Picture") }, class_name: "UserDoc"
  has_many :ratings, as: :rated_entity
  has_many :care_home_carer_mappings

  has_many :contacts
  has_many :references

  SEX = ["M", "F"]
  SPECIALITY = ["Generalist", "Geriatric Care", "Pediatric Care", "Mental Health"]
  ROLE = ["Care Giver", "Nurse", "Admin", "Agency"]
  TITLE = ["Mr", "Mrs", "Miss"]


  # Include default devise modules.
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :confirmable, :omniauthable

  include DeviseTokenAuth::Concerns::User


  scope :care_givers, -> { where role: "Care Giver" }
  scope :nurses, -> { where role: "Nurse" }
  scope :admins, -> { where role: "Admin"}
  scope :temps, -> { where "role = ? or role = ?", "Care Giver", "Nurse"}
  scope :active, -> { where active: true }

  after_save :update_coordinates
  before_save :check_verified
  before_save :check_accept_bank_transactions
  before_create :set_defaults
  before_create :add_unsubscribe_hash
  reverse_geocoded_by :lat, :lng
  before_destroy :check_for_shifts, prepend: true

  validate :password_complexity
  

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    errors.add :password, 'Complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end
  
  after_create :create_default_mapping
  def create_default_mapping
    AgencyUserMapping.create(agency_id: Agency.first.id, user_id: self.id, verified: false, accepted: true) if Agency.first && self.is_temp?
  end

  def index_user
    # This is to avoid the user being indexed with every request
    # as with this API app the user tokens get updated with every request due to device

    #logger.debug "index_user #{self.changed}"
    if( self.changed.length == 2 && self.changed[0] == "tokens" && self.changed[1] == "updated_at" )
      return
    else
      ThinkingSphinx::RealTime::Callbacks::RealTimeCallbacks.new(
        :user
      ).after_save self
    end

  end

  def latitude_in_radians
    Math::PI * lat / 180.0 if lat
  end

  def longitude_in_radians
    Math::PI * lng / 180.0 if lng
  end


  def add_unsubscribe_hash
    self.unsubscribe_hash = SecureRandom.hex
    self.subscription = true
  end

  def check_accept_bank_transactions
    if(self.accept_bank_transactions && self.accept_bank_transactions_changed?)
      self.accept_bank_transactions_date = Time.now
    end
  end

  def check_verified
    if(self.verified_changed? && self.verified)
      self.verified_on = Date.today
    end
    if(self.verified_changed? && !self.verified)
      # The user was unverified
      self.care_home_carer_mappings.update_all(enabled: false)
    end

    # If user has requested a deletion of her personal data
    if(self.delete_requested && self.delete_requested_changed?) 
      UserNotifierMailer.delete_requested(self.id).deliver_later
    end
  end

  def update_coordinates
    if(self.postcode && self.postcode_changed? && Rails.env != "test")
      GeocodeJob.perform_later(self)
    end
  end

  def is_temp?
    self.role == "Care Giver" || self.role == "Nurse"
  end

  def is_admin?
    self.role == "Admin"
  end

  def set_defaults
    self.total_rating = 0
    self.rating_count = 0
    self.delete_requested = false
    self.active = true
    self.phone = self.phone.gsub(/\s+/, "") 

    if(self.is_temp?)
      self.verified = false if self.verified == nil
    
      self.work_weekdays = true if self.work_weekdays == nil
      self.work_weeknights = true if self.work_weeknights == nil
      self.work_weekends = true if self.work_weekends == nil
      self.work_weekend_nights = true if self.work_weekend_nights == nil
    
      self.pause_shifts = false if self.pause_shifts == nil
      self.speciality = "Generalist" if self.speciality == nil
    end
    
  end

  def self.guest
    u = User.new
    u.role = "Guest"
    u.first_name = "Guest"
    u.last_name = "User"
    u.email = "guest.user@ubernurse.com"
    u.active = true

    return u
  end

  def verifiable_docs
    self.user_docs.not_rejected.not_expired
  end

  def image
    if(self.image_url.present?)
      return self.image_url
    elsif self.profile_pic
      self.profile_pic.doc.expiring_url(3000)
    else
      return "http://www.iconshock.com/img_vista/IPHONE/jobs/jpg/nurse_icon.jpg"
    end
  end

  def token_validation_response
    UserSerializer.new(self).as_json
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def send_sms_verification
    self.sms_verification_code = rand.to_s[2..6]
    self.save
    msg = "Your Connect Care phone verification code is: #{self.sms_verification_code}"
    send_sms(msg)
  end


  def send_sms(msg)
    to_phone = self.phone
    from_phone = ENV['TWILIO_NUMBER']

    if(Rails.env != 'test' && ENV["SEND_SMS"] == 'true')
      logger.debug "Sending sms '#{msg}' to #{self.email} @ #{to_phone} from #{from_phone}"

      twilio = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
      twilio.messages.create(
        from: from_phone,
        to: to_phone,
        body: msg
      )
      true
    else
      logger.debug "Not sending sms '#{msg}' to #{self.email} @ #{to_phone} from #{from_phone}. ENV['SEND_SMS'] = #{ENV['SEND_SMS']} & Rails.env = #{Rails.env}"
      false
    end


  end


  def confirm_sms_verification(code)
    self.phone_verified = (code == self.sms_verification_code)
    self.save
    return self.phone_verified
  end

  def mins_worked_in_month(date=Date.today)
    som = date.beginning_of_month
    eom = date.end_of_month
    month_shifts = self.shifts.joins(:staffing_request).where("staffing_requests.start_date >= ? and staffing_requests.start_date < ?", som, eom + 1.day)
    month_total_mins_worked = month_shifts.sum(:total_mins_worked)
    month_total_mins_worked
  end

  # for testing only in factories - do not use in prod
  def postcodelatlng=(postcodelatlng)
    self.postcode = postcodelatlng.postcode
    self.lat = postcodelatlng.latitude
    self.lng = postcodelatlng.longitude
  end

  def current_docs
    self.user_docs.not_expired.where(verified: true)
  end

  def care_homes
    CareHome.where(id: self.care_home_ids)
  end

  def care_home_ids
    ids = [self.care_home_id]
    ids.concat self.care_home.sister_care_homes.split(",").map{|x| x.to_i} if self.care_home && self.care_home.sister_care_homes
    ids
  end

  def belongs_to_care_home(care_home_id)
    self.care_home_ids.include?(care_home_id)
  end

  def belongs_to_agency(acgency_id)
    self.agency_user_mappings.collect(&:agency_id).include?(acgency_id)
  end

  def check_for_shifts
    logger.debug "check_for_shifts called"
    if self.shifts.length > 0
      logger.debug "check_for_shifts: Should not delete User as he has shifts"
      self.errors[:base] << "Cannot delete user who has been assigned shifts in the system. Use forget to scramble this users personla data."
      throw(:abort)
    end
  end


  def generate_password_reset_code
    self.password_reset_code = rand.to_s[2..5]
    self.save
    send_sms("Connuct password reset code: #{self.password_reset_code}")
    return self.password_reset_code
  end

  def self.try_password_reset_code(email, password_reset_code, password)

    user = User.where(email: email, password_reset_code: password_reset_code).first
    if(user)
      user.password = password
      user.password_reset_code = nil
      user.password_reset_date = Date.today
      return user.save
    else
      return false
    end
  end

  # Used for GDPR forget me
  def scramble_personal_data
    self.first_name = "Deleted"
    self.last_name = "Deleted"
    self.phone = "000000000"
    self.email = "deleted#{self.id}@deleted.com"
    self.uid = self.email
    self.address = "Deleted"
    self.postcode = PostCode.first.postcode
    self.bank_account = "00000000"
    self.sort_code = "000000"
    self.active = false
    self.pref_commute_distance = 0
    if self.save
      DeleteDocsJob.perform_later(self)
      return true
    else
      return false
    end
  end


end
