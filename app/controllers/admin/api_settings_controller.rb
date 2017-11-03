class Admin::ApiSettingsController < Admin::BaseController
  before_action :set_api_setting, only: [:show, :edit, :update, :destroy]

  # GET /api_settings
  # GET /api_settings.json
  def index
    @api_settings = ApiSetting.all
  end

  # GET /api_settings/1
  # GET /api_settings/1.json
  def show
  end

  # GET /api_settings/new
  def new
    @api_setting = ApiSetting.new
  end

  # GET /api_settings/1/edit
  def edit
  end

  # POST /api_settings
  # POST /api_settings.json
  def create
    @api_setting = ApiSetting.new(api_setting_params)

    respond_to do |format|
      if @api_setting.save
        format.html { redirect_to admin_api_settings_path, notice: 'Api setting was successfully created.' }
        format.json { render :show, status: :created, location: @api_setting }
      else
        format.html { render :new }
        format.json { render json: @api_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api_settings/1
  # PATCH/PUT /api_settings/1.json
  def update
    respond_to do |format|
      if @api_setting.update(api_setting_params)
        format.html { redirect_to admin_api_settings_path, notice: 'Api setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @api_setting }
      else
        format.html { render :edit }
        format.json { render json: @api_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_settings/1
  # DELETE /api_settings/1.json
  def destroy
    @api_setting.destroy
    respond_to do |format|
      format.html { redirect_to admin_api_settings_path, notice: 'Api setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_setting
      @api_setting = ApiSetting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_setting_params
      params.require(:api_setting).permit(:url, :client_id, :event_id, :api_auth_token, :active)
    end
end
