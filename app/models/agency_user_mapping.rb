
class AgencyUserMapping < ApplicationRecord
  validates_presence_of :agency_id, :user_id
  belongs_to :agency
  belongs_to :user

  scope :verified, -> { where(verified: true) }
  scope :not_accepted, -> { where(accepted: false) }

  before_save :update_user
  validate :check_accepted
  after_create :send_user_accept_notification

  def check_accepted
    if self.verified && self.verified_changed? && !self.accepted
      errors.add(:verified, "Cannot be verified till Care Home accepts. Please get the care home to accept you as the Agency")
      puts errors
    end
  end


  def update_user
    self.verified = false if self.verified == nil
    self.accepted = false if self.accepted == nil
    
  	if self.verified
  		self.user.verified = true
      self.user.verified_on = Date.today
  		self.user.save
      UserNotifierMailer.verification_complete(self.id).deliver_later if self.id
  	end
  end

  def send_user_accept_notification
    UserNotifierMailer.user_accept_agency_notification(self).deliver_later
  end

end
