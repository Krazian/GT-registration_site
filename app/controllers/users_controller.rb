class UsersController < ApplicationController
	before_action :set_user, except: [:submit_code]

	# Root page
	def submit_code
	end

	# Search if user with inputted registration code exists
	def post_user
		if params.has_key?(:code) && !params[:code].empty? && @user
			session[:current_edit] = params[:code]
			return redirect_to(@user.submitted == true ? users_completed_path(@user) : users_form_path(@user))
		else
			flash[:notice] = 'An invalid registration code was entered.'.html_safe
			render 'submit_code'
		end
	end

	# Form
	def form
		# if user is trying to access random number
		if session[:current_edit] != params[:code]
			return redirect_to(@user.submitted == true ? users_completed_path(@user) : users_root_path)
		end
	end

	# Update the record with new info
	def update
    if @user.update(register_params) && params[:submit]
   		@user.update(:submitted => true)
      # UserConfirmMailer.send_confirmation(@user).deliver
    	# UserConfirmMailer.notify_admin(@user).deliver
      sync_paperless(@user)
      redirect_to users_submit_path
    elsif @user.update(register_params) && params[:save]
    	flash[:notice] = "Your progress has been saved!".html_safe
    	render 'form'
    else
      flash[:error] = @user.errors.full_messages
      render "form"
    end
	end

	# Completion page
	def submitted

		if session[:current_edit] != params[:code]
			redirect_to users_root_path
		else
			UserConfirmMailer.notify_admin(@user).deliver
			session.delete(:current_edit)
		end
	end

	def completed
		if @user.submitted == false
			redirect_to users_form_path(@user)
		end
	end

	private
		#Setting instance variable at the start of each action
		def set_user
	    id = params.has_key?(:code) ? params[:code] : params[:id]
	    @user = User.find_by_registration_code(id)
		end

		# Strong params
		def register_params
			params.require(:user).permit(:registration_code,:first_name,:last_name,
																	:preferred_first_name,:preferred_last_name,:gender,
																	:email,:mobile_number,:mobile_device,:iphone,:android,:blackberry,:ipad,:tablet,
																	:other,:job_title,:assistant_first_name,:assistant_last_name,
																	:assistant_email,:arrival_date_and_time,:inbound_destination,
																	:departure_date_and_time,:outbound_destination,:require_hotel,
																	:emergency_first_name,:emergency_last_name,:emergency_mobile_number,
																	:emergency_relationship,:allergies,:professional,:personal,
																	:month_of_birth,:day_of_birth,:hometown,:fav_sports_team_or_player,
																	:fav_song,:first_position_at_exxonmobil,:year_started_at_exxonmobil,
																	:photo,:photo_file_name,:photo_content_type,:photo_file_size)
		end

		def sync_paperless(user)
			# PaperlessSyncWorker.perform_async(user.id)
		end
end
