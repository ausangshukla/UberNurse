class Hospital < ApplicationRecord

	acts_as_paranoid
	after_save ThinkingSphinx::RealTime.callback_for(:hospital)
	
	has_many :users
	has_many :staffing_requests

	before_save :update_coordinates

	def update_coordinates
		post_code = PostCode.where(postcode: self.postcode).first
		self.lat = post_code.latitude
		self.lng = post_code.longitude
	end
end
