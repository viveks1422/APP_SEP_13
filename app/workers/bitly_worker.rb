class BitlyWorker
	include Sidekiq::Worker
	sidekiq_options retry: false
	
	def perform(event_id)
		event = Event.find(event_id)
		user = "birmignhamevents"
		apiKey = "6205cc69013180588139b5dacc743eee90ff3c0f"
		bitly_url = "https://api-ssl.bitly.com/v3/shorten?access_token=#{apiKey}&longUrl=#{event.link}"
		buffer = open(bitly_url, "UserAgent" => "Ruby-ExpandLink").read
		result = JSON.parse(buffer)
		short_url = result['data']["url"]
		event.update_attribute(:link, short_url)
	end
end