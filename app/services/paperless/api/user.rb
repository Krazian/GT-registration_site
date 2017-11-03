class Paperless::Api::User
  def initialize(registrant)
    @registrant = registrant
    settings = ApiSetting.find_by_active(true)
    @event_id = settings.event_id
    @token = settings.api_auth_token
    @base_url = settings.url
  end

  def register
    register_participant
  end

  def upload_photo
    return false unless @registrant.paperless_attendee_id && @registrant.photo?
    data = {
        method: :post,
        headers: {
            'X-AUTH-TOKEN': @token,
        },
        payload: {
            user_avatar: File.new(@registrant.photo.path, 'rb'),
            event_id: 101,
            event_attendee_id: ea.id,
            multipart: true,
        },
        url: attendee_update_url
    }
    r = RestClient::Request.execute(data)
    JSON.parse(r)
  end

  private
  def register_participant
    data = request_data(participant_attributes)

    if @registrant.photo?
      path = @registrant.photo.path
      data[:payload][:user_avatar] = File.new(path, 'rb') if File.exists?(path)
    end

    begin
      res = RestClient::Request.execute(data)
    rescue => e
      return false
    end

    parsed = JSON.parse!(res)
    p parsed
    @registrant.update(paperless_attendee_id: parsed['attendee']['id'])
  end

  def request_data(attributes)
    {
        url: registration_url,
        method: :post,
        headers: {
            'X-AUTH-TOKEN': @token,
        },
        payload: {
            attendee: attributes,
            multipart: true
        }
    }
  end

  def registration_url
    "#{@base_url}/api/v1/admin/events/#{@event_id}/registrations"
  end

  def attendee_update_url
    "#{@base_url}/api/v1/admin/attendees/#{@registrant.paperless_attendee_id}"
  end

  def participant_attributes
    attendee_required_fields.merge(attendee_update_attributes)
  end

  def attendee_required_fields
    {
        first_name: @registrant.first_name,
        last_name: @registrant.last_name,
        email: @registrant.email,
        password: 'testing123',
        password_confirmation: 'testing123'
    }
  end

  def attendee_update_attributes
    {
        #paperless field: database attribute
        badge_name: @registrant.preferred_first_name+" "+@registrant.preferred_last_name,
        gender: translate_gender(@registrant.gender),
        job_title: @registrant.job_title,
        notes: @registrant.allergies,
        phone: @registrant.mobile_number,
        mobile_phone: @registrant.mobile_device,
        poc_first_name: @registrant.assistant_first_name,
        poc_last_name: @registrant.assistant_last_name,
        poc_email: @registrant.assistant_email,
        additional_info1: @registrant.arrival_date_and_time,
        additional_info2: @registrant.inbound_destination,
        additional_info3: @registrant.departure_date_and_time,
        additional_info4: @registrant.outbound_destination,
        additional_info5: @registrant.require_hotel,
        additional_info6: @registrant.emergency_first_name,
        additional_info7: @registrant.emergency_last_name,
        additional_info8: @registrant.emergency_mobile_number,
        additional_info9: @registrant.emergency_relationship,
        additional_info10: @registrant.professional,
        additional_info11: @registrant.personal,
        additional_info12: @registrant.month_of_birth,
        additional_info13: @registrant.day_of_birth,
        additional_info14: @registrant.hometown,
        additional_info15: @registrant.fav_sports_team_or_player,
        additional_info16: @registrant.fav_song,
        additional_info17: @registrant.first_position_at_exxonmobil,
        additional_info18: @registrant.year_started_at_exxonmobil,
        prid: @registrant.registration_code
    # UNMAPPED FIELDS
      # @registrant.paperless_id
    }
  end
  
  def translate_gender(gender)
    case gender
      when 'Female'
        'FEMALE'
      when 'Male'
        'MALE'
      else
        'UNSPECIFIED'
    end
  end
end