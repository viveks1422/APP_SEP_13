class EventTiming < ActiveRecord::Base
  belongs_to :event
  attr_accessible :date, :time

  validates_presence_of :date, :time
end
