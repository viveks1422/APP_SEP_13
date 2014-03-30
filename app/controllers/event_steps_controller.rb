class EventStepsController < ApplicationController
	include Wicked::Wizard
	require 'net/http'
	require 'uri'
	require 'mime/types'

	before_filter :check_extension_of_remote_url, :only =>[:update]
	steps :event_info, :image

	def show
		@event = Event.find(session[:event_id])
		render_wizard
	end

	def update
		@event = Event.find(session[:event_id])
		@event.attributes = params[:event]
		case step
		when :image
			if !@event.link.blank? || @event.link_changed?
				BitlyWorker.perform_async(@event.id)
			end
		end
		render_wizard(@event)
	end

	def edit
		@event = Event.find(session[:event_id])
		render_wizard
	end

private

	def finish_wizard_path
		verify_path(@event)
	end

	# check extension of remote url starts from here
	def check_extension_of_remote_url
	    if params["event"]["remote_image_url"].present? && File.extname(params["event"]["remote_image_url"]).blank? && !params[:event][:remote_image_url].blank?
	    	uri = URI.parse(params["event"]["remote_image_url"])
		    http = Net::HTTP.new(uri.host, uri.port)
		    http.use_ssl = true if uri.scheme == 'https'
		    request = Net::HTTP::Head.new(uri.request_uri)
		    response = http.request(request)
		    content_type = response['Content-Type']
		    @image_extension = MIME::Types[content_type].first.extensions.first
		    params["event"]["remote_image_url"] = 'jpg_jpeg_png_gif'.include?(@image_extension)? self.params["event"]["remote_image_url"]+"."+@image_extension   : self.params["event"]["remote_image_url"]
		    $pass_image = 'jpg_jpeg_png_gif'.include?(@image_extension)? false : true
	   end
	end
end
