class Rate < ApplicationRecord
  
  belongs_to :care_home
  
  class << self
    include RatesHelper
  end

end
