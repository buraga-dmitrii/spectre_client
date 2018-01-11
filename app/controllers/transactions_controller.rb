class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    unless transaction_params[:account_id]
      redirect_to logins_path and return
    end

    @account = Account.joins(login: :customer)
      .where(id: transaction_params[:account_id])
      .where('customers.id = ?', current_user.customer.id)
      .first

    if @account
      @transactions = @account.transactions
    else  
      redirect_to logins_path 
    end
  end

  
  private
  
    def transaction_params
      params.permit(:account_id)
    end
end
