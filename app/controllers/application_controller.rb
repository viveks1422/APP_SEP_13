class ApplicationController < ActionController::Base
  protect_from_forgery

  require 'unidecoder'

  	def authenticate_admin_user!
  		authenticate_user!
  		unless current_user.admin?
  			flash[:alert] =  "This area is restricted to administrators only."
  			redirect_to root_path
  		end
  	end
end
