class ChargesController < ApplicationController
	def index
	end

	def new
		
	end

	def create

		@event = Event.find(session[:event_id])

		#Amount in cents
		@amount = 99

		customer = Stripe::Customer.create(
			:email => "devan.beitel@gmail.com",
			:card => params[:stripeToken]
		)

		charge = Stripe::Charge.create(
			:customer => customer.id,
			:amount => @amount,
			:description => 'Birmingham Events - Single Event Fee',
			:currency => 'usd'
		)

		@event.update_attributes(charge: true)
		MailersWorker.perform_async(@event.id)
		redirect_to root_path, :notice => "Thanks for listing your event! Check your email for your event details."

	rescue Stripe::CardError => e
		flash[:error] = e.message
		redirect_to charges_path
	end
end
