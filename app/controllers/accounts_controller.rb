class AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    unless account_params[:login_id]
      redirect_to logins_path and return
    end    

    @login = Login.where(id: account_params[:login_id])
                  .where(customer_id: current_user.customer.id)
                  .first

    if @login
      @accounts = @login.accounts     
    else
     redirect_to logins_path
    end 
  end

  private

    def account_params
      params.permit(:login_id)
    end
end
