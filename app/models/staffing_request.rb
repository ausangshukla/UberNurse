class StaffingRequest < ApplicationRecord

  acts_as_paranoid
  has_paper_trail
  after_save ThinkingSphinx::RealTime.callback_for(:staffing_request)

  REQ_STATUS = ["Open", "Closed"]
  BROADCAST_STATUS =["Sent", "Failed"]

  belongs_to :hospital
  belongs_to :user
  has_many :staffing_responses
  has_one :payment

  #after_save ThinkingSphinx::RealTime.callback_for(:staffing_request)

  scope :open, -> {where(request_status:"Open")}
  scope :closed, -> {where(request_status:"Closed")}
  scope :not_broadcasted, -> {where("broadcast_status <> 'Sent' OR broadcast_status is null")}

  before_create :open_request

  def open_request
    # We now have auto approval
    self.request_status = "Open"
  end

  before_save :update_response_status
  def update_response_status
    if( self.request_status_changed? && self.request_status == 'Closed')
    	# Ensure all responses are also closed so they dont show up on the UI
      self.staffing_responses.each do |resp|	
        resp.response_status = "Closed"
        resp.save
      end
    end
  end

  def prev_versions
  	self.versions.collect(&:reify)
  end

end
