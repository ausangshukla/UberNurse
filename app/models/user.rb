class User < ApplicationRecord
  
  acts_as_paranoid
  after_save ThinkingSphinx::RealTime.callback_for(:user)

  validates_presence_of :first_name, :last_name, :email, :role, :postcode, :phone
  
  belongs_to :hospital, optional: true
  has_many :staffing_requests
  has_many :staffing_responses
  has_many :user_docs, -> { order(:verified=>:desc) }
  has_one :profile_pic, -> { where(doc_type: "Profile Pic") }, class_name: "UserDoc" 

  SEX = ["M", "F"]
  SPECIALITY = ["Geriatric Care", "Pediatric Care", "Trauma"]
  ROLE =["Care Giver", "Admin"]

  
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable

  include DeviseTokenAuth::Concerns::User


  scope :care_givers, -> { where role: "Care Giver" }
  scope :verified, -> { where verified: true }
  scope :active, -> { where active: true }
  scope :admins, ->(hospital_id){ where role: "Admin", hospital_id: hospital_id }
  scope :employees, ->(hospital_id) { where role: "Employee", hospital_id: hospital_id }

  after_save :update_coordinates
  before_create :update_rating
  reverse_geocoded_by :lat, :lng

  def update_coordinates
    if(self.postcode_changed?)
      GeocodeJob.perform_later(self)
    end
  end

  def update_rating
    self.total_rating = 0
    self.rating_count = 0
    self.active = true
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

  def image
    self.image_url ? self.image_url : "http://www.iconshock.com/img_vista/IPHONE/jobs/jpg/nurse_icon.jpg"
  end
end
