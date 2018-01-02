class LoginsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_login, only: [:show, :edit, :update, :destroy, :login_refresh, :login_reconnect]

  # GET /logins
  # GET /logins.json
  def index
    if params[:refresh]
      SpectreApi.update_logins(current_user) 
    end
    @logins = current_user.customer.logins
  end

  def update_logins
  end

  def login_refresh
    if @login
      callback_url = SpectreApi.refresh_login(@login, update_logins_url) 
      redirect_to callback_url
    else  
      redirect_to logins_url
    end   
  end

  def login_reconnect
    if @login
      callback_url = SpectreApi.reconnect_login(@login, update_logins_url) 
      redirect_to callback_url
    else
      redirect_to logins_url
    end  
  end
  # GET /logins/1
  # GET /logins/1.json
  def show
  end

  # GET /logins/new
  def new
    @login = Login.new
  end

  # GET /logins/1/edit
  def edit
  end

  def login_create 
    if current_user.customer
      callback_url = SpectreApi.create_login(current_user.customer.customer_id, update_logins_url)
      redirect_to callback_url
    end
  end

  # POST /logins
  # POST /logins.json
  def create
    #  if current_user.customer
    #   api = Saltedge.new(CLIENT_ID, SERVICE_SECRET)
    #   response = api.request("POST", "https://www.saltedge.com/api/v3/tokens/create", {"data" => {"customer_id" => current_user.customer.customer_id, "fetch_type" => "recent", "return_to" => "#{root_url}"}})
    #   hash = JSON.parse(response.body)

    #   redirect_to hash['data']['connect_url']
    # end

    @login = Login.new(login_params)

    respond_to do |format|
      if @login.save
        format.html { redirect_to @login, notice: 'Login was successfully created.' }
        format.json { render :show, status: :created, location: @login }
      else
        format.html { render :new }
        format.json { render json: @login.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logins/1
  # PATCH/PUT /logins/1.json
  def update
    respond_to do |format|
      if @login.update(login_params)
        format.html { redirect_to @login, notice: 'Login was successfully updated.' }
        format.json { render :show, status: :ok, location: @login }
      else
        format.html { render :edit }
        format.json { render json: @login.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logins/1
  # DELETE /logins/1.json
  def destroy
    SpectreApi.destroy_login(@login) 
    @login.destroy
    respond_to do |format|
      format.html { redirect_to logins_url, notice: 'Login was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_login
      @login = Login.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def login_params
      params.require(:login).permit(:login_id, :hashid, :status, :provider, :customer_id)
    end
end
