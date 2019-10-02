class AgencyCareHomeMapping < ApplicationRecord
  validates_presence_of :agency_id, :care_home_id
  belongs_to :agency
  belongs_to :care_home

  after_save ThinkingSphinx::RealTime.callback_for(:agency_care_home_mapping)
  before_save :update_care_home
  before_create :set_defaults
  validate :check_accepted
  after_create :send_care_home_accept_notification

  scope :verified, -> { where(verified: true) }
  scope :not_accepted, -> { where(accepted: false) }

  def check_accepted
    if self.verified && self.verified_changed? && !self.accepted
      errors.add(:verified, "Cannot be verified till Care Home accepts. Please get the care home to accept you as the Agency")
      puts errors
    end
  end

  def set_defaults
    self.verified = false if self.verified == nil
    self.accepted = false if self.accepted == nil
    self.accepted = true  
  end

  def update_care_home  
  	if self.verified && self.verified_changed?
  		self.care_home.verified = true
  		self.care_home.save
      UserNotifierMailer.care_home_verified(self.id).deliver_later
  	end
  end

  def send_care_home_accept_notification
    UserNotifierMailer.care_home_accept_agency_notification(self).deliver_later unless self.accepted
  end
end
