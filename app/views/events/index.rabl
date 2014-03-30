collection @events
attributes :title, :venue, :description, :price, :address, :featured, :catId, :link, :latitude, :longitude
node :imageUrl |events| 
	if !events.image.url(:main).blank? 
		events.image.url(:main)
	else http://eventsapp.us/assets/default.jpg

node :imageThumbUrl |events|
	if !events.image.url(:thumb).blank?
		events.image.url(:thumb)
	else http://eventsapp.us/assets/thumb.jpg