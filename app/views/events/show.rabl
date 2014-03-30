object @events
attributes :title, :date, :time, :venue, :description, :price, :address, :featured, :catId, :link, :latitude, :longitude
node(:imageUrl){|event| events.image.url(:main)}
node(:imageThumbUrl){|event| events.image.url(:thumb)}