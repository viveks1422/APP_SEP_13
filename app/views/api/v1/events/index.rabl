collection @events

attributes :title, :venue, :description, :price, :eventaddress, :featured, :catId, :link, :latitude, :longitude

child :event_timings do
	attributes :date, :time
end

node :imageUrl do |events|
	if events.image.blank?
		"http://www.eventsapp.us/assets/default.jpg"
	else "http://www.eventsapp.us" + events.image.url(:main)
	end
end
node :imageThumbUrl do |events|
	if events.image.blank?
		"http://www.eventsapp.us/assets/thumb.jpg"
	else "http://www.eventsapp.us" + events.image.url(:thumb)
	end
end