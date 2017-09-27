class TransactionsController < ApplicationController
  before_action :require_login
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @transactions = Transaction.all
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  def new
    @transaction = Transaction.new
    @local_clients = Client.where(store_token: current_store.token).to_a.pluck(:user_token)
    @clients = @local_clients.map { |lc| [get_full_name(lc), lc] }
  end

  def get_full_name(user_token)
    response = User.get_request("https://shared-sandbox-api.marqeta.com/v3/users/#{user_token}")
    user_data = response.parsed_response
    return "#{user_data['first_name']} #{user_data['last_name']}"
  end

  def create
    @store = current_store

    respond_to do |format|
      # post request instead
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    helper_method :get_full_name
    def require_login
      unless logged_in?
        flash[:danger] = 'You must login to create a transaction.'
        redirect_to '/login'
      end
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:user_token, :business_token, :card_token, :amount, :state, :type)
    end
end
