require 'rubygems'
require 'zip'
class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :sync_paperless]

  # GET /users
  # GET /users.json
def index
    if params[:commit] == "Search"
      @got_hits = true
      if params[:badge][:search_option] == "Name"
        @users = User.search_name(params[:badge][:name_search]).paginate(:page => params[:page], :per_page => 10)
      elsif params[:badge][:search_option] == "Date & Time"
        @users = User.search_date_time(params[:badge]["start_time(1i)"],params[:badge]["start_time(2i)"],params[:badge]["start_time(3i)"],params[:badge]["start_time(4i)"],params[:badge]["start_time(5i)"],params[:badge]["end_time(1i)"],params[:badge]["end_time(2i)"],params[:badge]["end_time(3i)"],params[:badge]["end_time(4i)"],params[:badge]["end_time(5i)"])
      end 
    else
      @got_hits = false
      @users = User.all.paginate(:page => params[:page], :per_page => 10).order('last_name ASC, first_name ASC')
    end

    respond_to do |format|
      format.html
      format.csv{
        if @got_hits && @users.length > 0
          input_filenames = {}
          @users.each do |file|
            if file.id < 10
             input_filenames["#{Rails.root}/public/system/users/photos/000/000/00#{file.id}/original/"] = file.photo_file_name ? file.photo_file_name : ""
            elsif file.id < 100
              input_filenames["#{Rails.root}/public/system/users/photos/000/000/0#{file.id}/original/"] = file.photo_file_name ? file.photo_file_name : ""
            elsif file.id < 1000
              input_filenames["#{Rails.root}/public/system/users/photos/000/000/#{file.id}/original/"] = file.photo_file_name ? file.photo_file_name : ""
            elsif file.id < 1010
              input_filenames["#{Rails.root}/public/system/users/photos/000/001/00#{file.id.to_s[3..-1]}/original/"] = file.photo_file_name ? file.photo_file_name : ""
            elsif file.id < 1100
              input_filenames["#{Rails.root}/public/system/users/photos/000/001/0#{file.id.to_s[2..-1]}/original/"] = file.photo_file_name ? file.photo_file_name : ""
            else
              input_filenames["#{Rails.root}/public/system/users/photos/000/001/#{file.id.to_s[1..-1]}/original/"] = file.photo_file_name ? file.photo_file_name : ""
            end
          end

          # Create the zip file of photos
          zipfile_name = "#{Rails.root}/public/system/users/report_zips/" << "attendee-badge-photos-" << Time.now.strftime("%Y%m%d%H%M%S").to_s << ".zip"
          Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
            input_filenames.each do |folder,filename|
              zipfile.add(filename, folder + filename)
            end
          end

          # Create entry in database to record report
          AttendeeReport.create({
            :csv_file_name => "attendee_report-#{Time.now().to_formatted_s(:db)}.csv",
            :csv_link => request.original_url.gsub("users","attendee_reports"),
            :zip_file_name => zipfile_name.split("/").last,
            :zip_link => request.base_url << "/system/users/report_zips/" << zipfile_name.split("/").last
          })
          redirect_to admin_attendee_reports_path
        else
          redirect_to admin_users_path
        end
      }
    end

end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find_by_registration_code(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(register_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(register_params)
        format.html { redirect_to admin_users_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sync_paperless
    unless @user.email? && @user.first_name? && @user.last_name?
      redirect_to :back, notice: 'User lacks required fields.' and return
    end

    begin
      p = Paperless::Api::User.new(@user)
      p.register
      rescue => e
      redirect_to :back, notice: 'Error syncing user.' and return
    end
    redirect_to :back, notice: 'Succesfully synced with Paperless.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by_registration_code(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
          params.require(:user).permit(:registration_code,:first_name,:last_name,
                                  :preferred_first_name,:preferred_last_name,:gender,
                                  :email,:mobile_number,:iphone,:android,:blackberry,:ipad,:tablet,
                                  :other,:job_title,:assistant_first_name,:assistant_last_name,
                                  :assistant_email,:arrival_date_and_time,:inbound_destination,
                                  :departure_date_and_time,:outbound_destination,:require_hotel,
                                  :emergency_first_name,:emergency_last_name,:emergency_mobile_number,
                                  :emergency_relationship,:allergies,:professional,:personal,
                                  :month_of_birth,:day_of_birth,:hometown,:fav_sports_team_or_player,
                                  :fav_song,:first_position_at_exxonmobil,:year_started_at_exxonmobil,
                                  :photo,:photo_file_name,:photo_content_type,:photo_file_size)
  end
end