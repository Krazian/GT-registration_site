json.array!(@admin_api_settings) do |admin_api_setting|
  json.extract! admin_api_setting, :id
  json.url admin_api_setting_url(admin_api_setting, format: :json)
end
