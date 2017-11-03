require "csv"

class User < ApplicationRecord
	validates :registration_code, presence: true, uniqueness: true
	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :email, presence: true, uniqueness: true

	has_attached_file :photo, styles: {}, allow_blank: true
  validates_with AttachmentSizeValidator, attributes: :photo, less_than: 100.megabytes
  validates_attachment :photo,
  content_type: { content_type: ["image/jpg", "image/jpeg", "image/gif", "image/tiff", "image/png"]}, allow_blank: true

  def to_param
  	registration_code
  end

  # Rewrites name of file to make more uniform
	def rename_photo_file_name
    extension = File.extname(photo_file_name).downcase
    self.photo.instance_write :file_name, "#{self.last_name.gsub(/[^0-9A-Za-z\-]/, '')}-#{self.first_name.gsub(/[^0-9A-Za-z\-]/, '')}-#{self.registration_code}.#{extension}"
	end

	def self.search_name(name)
		where("first_name LIKE ? OR last_name LIKE ?", "%#{name}%", "%#{name}%")
	end
	
	def self.search_date_time(syear,smonth,sday,shour,sminute,eyear,emonth,eday,ehour,eminute)
	  where("updated_at >= ? AND updated_at <= ?", Time.new("#{syear}","#{smonth}","#{sday}","#{shour}","#{sminute}", 00, "-04:00"),Time.new("#{eyear}","#{emonth}","#{eday}","#{ehour}","#{eminute}", 00, "-04:00")) 
	end

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

  before_save do
  	# Compress all checked devices into a single field
  	devices = %w[iphone android blackberry ipad tablet other]
  	checked_devices = []
  	devices.each do |device|
  		if self.read_attribute(device) == true
  			checked_devices.push(device)
  		end
  	end

		if self.email == ""
			self.email = nil
		end

		self.first_name = self.first_name.strip.capitalize unless self.first_name.nil?
	  self.last_name = self.last_name.strip.capitalize unless self.last_name.nil?
		self.preferred_first_name = self.preferred_first_name.strip.capitalize unless self.preferred_first_name.nil?
		self.preferred_last_name = self.preferred_last_name.strip.capitalize unless self.preferred_last_name.nil?
		self.gender = self.gender.strip.capitalize unless self.gender.nil?
		self.email = self.email.strip.downcase unless self.email.nil?
		self.mobile_number = self.mobile_number.strip unless self.mobile_number.nil?
		# self.mobile_device = checked_devices.join(", ") #UNCOMMENT WHEN SEEDING
		self.job_title = self.job_title.strip.capitalize unless self.job_title.nil?
		self.assistant_first_name = self.assistant_first_name.strip.capitalize unless self.assistant_first_name.nil?
		self.assistant_last_name = self.assistant_last_name.strip.capitalize unless self.assistant_last_name.nil?
		self.assistant_email = self.assistant_email.strip.downcase unless self.assistant_email.nil?
		self.arrival_date_and_time = self.arrival_date_and_time.strip unless self.arrival_date_and_time.nil?
		self.inbound_destination = self.inbound_destination.strip.capitalize unless self.inbound_destination.nil?
		self.departure_date_and_time = self.departure_date_and_time.strip unless self.departure_date_and_time.nil?
		self.outbound_destination = self.outbound_destination.strip.capitalize unless self.outbound_destination.nil?
		self.require_hotel = self.require_hotel.strip unless self.require_hotel.nil?
		self.emergency_first_name = self.emergency_first_name.strip.capitalize unless self.emergency_first_name.nil?
		self.emergency_last_name = self.emergency_last_name.strip.capitalize unless self.emergency_last_name.nil?
		self.emergency_mobile_number = self.emergency_mobile_number.strip unless self.emergency_mobile_number.nil?
		self.emergency_relationship = self.emergency_relationship.strip.capitalize unless self.emergency_relationship.nil?
		self.allergies = self.allergies.strip.capitalize unless self.allergies.nil?
		self.professional = self.professional.strip.capitalize unless self.professional.nil?
		self.personal = self.personal.strip.capitalize unless self.personal.nil?
		self.month_of_birth = self.month_of_birth.strip.capitalize unless self.month_of_birth.nil?
		self.day_of_birth = self.day_of_birth.strip.capitalize unless self.day_of_birth.nil?
		self.hometown = self.hometown.strip.capitalize unless self.hometown.nil?
		self.fav_sports_team_or_player = self.fav_sports_team_or_player.strip.capitalize unless self.fav_sports_team_or_player.nil?
		self.fav_song = self.fav_song.strip.capitalize unless self.fav_song.nil?
		self.first_position_at_exxonmobil = self.first_position_at_exxonmobil.strip.capitalize unless self.first_position_at_exxonmobil.nil?
		self.year_started_at_exxonmobil = self.year_started_at_exxonmobil.strip unless self.year_started_at_exxonmobil.nil?
		
		# Change name of photo name to match actual photo name
		if self.photo_file_name.nil?
		else
			rename_photo_file_name
			extension = self.photo_file_name.split(".").last
			self.photo_file_name = "#{self.last_name.gsub(/[^0-9A-Za-z\-]/, '')}-#{self.first_name.gsub(/[^0-9A-Za-z\-]/, '')}-#{self.registration_code}.#{extension}"
		end
	end
end