class LoginsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_login, only: [:destroy, :login_refresh, :login_reconnect]

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
 
  def create
   if current_user.customer
      callback_url = SpectreApi.create_login(
                      current_user.customer.customer_id,
                      update_logins_url)
      redirect_to callback_url
    end
  end

  def destroy
    SpectreApi.destroy_login(@login) 
    @login.destroy
    respond_to do |format|
      format.html { redirect_to logins_url, notice: 'Login was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_login
      @login = Login.find(params[:id])
    end
end
