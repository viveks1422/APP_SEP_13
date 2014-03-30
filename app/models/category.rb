class Category < ActiveRecord::Base
  attr_accessible :catId, :name
  belongs_to :event
end
