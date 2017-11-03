require "csv"
class AttendeeReport < ActiveRecord::Base
	def self.to_csv
		attributes = %w[registration_code first_name last_name preferred_first_name preferred_last_name gender email mobile_number mobile_device job_title assistant_first_name assistant_last_name assistant_email arrival_date_and_time inbound_destination departure_date_and_time outbound_destination require_hotel emergency_first_name emergency_last_name emergency_mobile_number emergency_relationship allergies professional personal month_of_birth day_of_birth hometown fav_sports_team_or_player fav_song first_position_at_exxonmobil year_started_at_exxonmobil submitted created_at updated_at photo_file_name]
		CSV.generate(headers: true) do |csv|
			headers = []
			attributes.each do |column|
				headers << column.titleize
			end
			csv << headers
			all.each do |person|
				csv << person.attributes.values_at(*attributes)
			end
		end
	end

	def self.search(syear,smonth,sday,shour,sminute,eyear,emonth,eday,ehour,eminute)
	  where("updated_at >= ? AND updated_at <= ?", Time.new("#{syear}","#{smonth}","#{sday}","#{shour}","#{sminute}", 00, "-04:00"),Time.new("#{eyear}","#{emonth}","#{eday}","#{ehour}","#{eminute}", 00, "-04:00")) 
	end
end