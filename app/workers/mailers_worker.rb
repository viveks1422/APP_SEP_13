class MailersWorker
	include Sidekiq::Worker
	# sidekiq_options retry: false

	def perform(event_id)
		event = Event.find(event_id)
		EventMailer.event_creation(event).deliver
	end
end