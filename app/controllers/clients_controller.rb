class ClientsController < ApplicationController
  before_action :require_login
  before_action :set_client, only: [:edit, :update, :destroy]

  def index
    @clients = Client.where(store_token: current_store.token)
    @users = @clients.map { |client| retrieve_user_data(client.user_token) unless client.user_token.empty? }
  end

  def show
    @client = Client.find(params[:id])
    @local_user = get_local_user_by_token(@client.user_token)
    @user_cards = retrieve_user_card_data(@client.user_token)
    @user_data = retrieve_user_data(@client.user_token)
    @status_options = ['ACTIVE', 'SUSPENDED', 'TERMINATED']
    if @user_cards['count'] > 0
      funding_source = Card.get_funding_source(@client.user_token)
      funding_source = funding_source['data'].first if funding_source['count'] > 0
      @transactions = Transaction.get_request("transactions/fundingsource/#{funding_source['token']}")
    end
  end

  def new
    @client = Client.new
  end

  def create
    if params['client'].nil? || params['client']['token'].empty?
      flash[:danger] = "Please select a client and try again"
      redirect_to new_client_path
    else
      @client = Client.create(
        user_token: params['client']['token'],
        store_token: current_store.token
      )

      respond_to do |format|
        if @client.save
          flash[:success] = 'Client was successfully created.'
          format.html { redirect_to @client }
          format.json { render :show, status: :created, location: @client }
        else
          format.html { render :new }
          format.json { render json: @client.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def activate
    @client = Client.find(params[:client_id])
    @body = {
      :card_token => params['card_token'],
      :state => params['status'],
      :channel => 'API'
    }.to_json
    @request = Client.post_card_transitions(@body)
    unless @request['error_code'].nil?
      flash[:danger] = @request['error_message']
    end
    redirect_to client_path(@client)
  end

  def destroy
    @client.destroy
    respond_to do |format|
      flash[:success] = 'Client was successfully destroyed.'
      format.html { redirect_to clients_path }
      format.json { head :no_content }
    end
  end

  def get_local_user_by_token(user_token)
    User.where(token: user_token).to_a
  end

  def retrieve_user_card_data(user_token)
    Card.get_request("cards/user/#{user_token}").parsed_response
  end

  def retrieve_user_data(user_token)
    User.get_request("users/#{user_token}").parsed_response
  end

  private
    helper_method :assemble_full_name
    helper_method :get_local_user_by_token
    def require_login
      unless logged_in?
        flash[:danger] = 'You must login to access clients.'
        redirect_to '/login'
      end
    end
    def set_client
      @client = Client.find(params[:client_id])
    end

    def client_params
      params.require(:user).permit(:user_token, :store_token)
    end
end
