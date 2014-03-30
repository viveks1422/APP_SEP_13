module Api
	module V1
		class EventsController < ApplicationController
			before_filter :restrict_access
			respond_to :json

			def index
				@events = Event.paid.all

				respond_with { @events }
			end

			def featured
				@events = Event.paid.featured.all

				respond_with { @events }
			end

		private

			def restrict_access
				api_key = ApiKey.find_by_access_token(params[:access_token])
				head :unauthorized unless api_key
			end
		end
	end
end