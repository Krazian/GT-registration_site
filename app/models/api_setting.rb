class ApiSetting < ActiveRecord::Base
	validates :url, presence: true
	validates :event_id, presence: true
	validates :api_auth_token, presence: true
end
