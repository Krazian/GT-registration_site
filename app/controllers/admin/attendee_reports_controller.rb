require 'rubygems'
require 'zip'
class Admin::AttendeeReportsController < Admin::BaseController
  def index
    @reports = AttendeeReport.all.order("id DESC")
    respond_to do |format|
      format.html{}
      format.csv{
        if defined? params[:badge]["start_time(1i)"]
        @reports = User.search(params[:badge]["start_time(1i)"],params[:badge]["start_time(2i)"],params[:badge]["start_time(3i)"],params[:badge]["start_time(4i)"],params[:badge]["start_time(5i)"],params[:badge]["end_time(1i)"],params[:badge]["end_time(2i)"],params[:badge]["end_time(3i)"],params[:badge]["end_time(4i)"],params[:badge]["end_time(5i)"]).order("updated_at ASC")
        send_data @reports.to_csv, filename: "attendee_report-#{Time.now().to_formatted_s(:db)}.csv"
        else
        @reports = User.all
        send_data @reports.to_csv, filename: "attendee_report-#{Time.now().to_formatted_s(:db)}.csv"
        end
      }
    end
  end
end