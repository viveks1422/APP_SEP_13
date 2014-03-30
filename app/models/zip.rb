class Zip < ActiveRecord::Base
  attr_accessible :zip_code, :zip_name
  belongs_to :event
end
