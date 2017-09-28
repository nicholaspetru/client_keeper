class TransactionsController < ApplicationController
  before_action :require_login
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  @@simulate_base_url = "https://shared-sandbox-api.marqeta.com/v3/simulate/financial"

  def index
    @transactions = Transaction.all
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  def begin
    @transaction = Transaction.new
    @local_clients = Client.where(store_token: current_store.token).to_a.pluck(:user_token)
    @clients = @local_clients.map { |lc| [get_full_name(lc), lc] }
  end

  def begin_with_client
    @client = Client.where(user_token: params[:user_token], store_token: current_store.token).first
    redirect_to "/clients/#{@client.id}/transactions/new"
  end

  def new
    @transaction = Transaction.new
    @client = Client.find(params[:client_id])
    @user = User.get_request("https://shared-sandbox-api.marqeta.com/v3/users/#{@client.user_token}").parsed_response
    @cards = Card.get_request("https://shared-sandbox-api.marqeta.com/v3/cards/user/#{@client.user_token}").parsed_response
    @card_list = prepare_cards_dropdown(@cards)
  end

  def get_full_name(user_token)
    response = User.get_request("https://shared-sandbox-api.marqeta.com/v3/users/#{user_token}")
    user_data = response.parsed_response
    return "#{user_data['first_name']} #{user_data['last_name']}"
  end

  def create
    @client = Client.find(params[:client_id])
    @store = Store.get_request("https://shared-sandbox-api.marqeta.com/v3/stores/#{current_store.token}")

    @body = {
      :amount => params['amount'],
      :card_token => params['card_token'],
      :mid => @store['mid']
    }.to_json

    @response = Transaction.post_request(@@simulate_base_url, @body)
    @transaction = @response['transaction']

    if !@response['error_code'].nil? || @transaction['state'] == 'DECLINED' || @transaction['state'] == 'ERROR'
      flash[:danger] = @response['error_message']
      flash[:danger] = "#{@transaction['state']}: #{@transaction['response']['memo']}"
      redirect_to new_client_transaction_path(@client)
    else
      flash[:success] = "#{@transaction['state']}: New transaction successfully created!"
      redirect_to client_path(@client)
    end
  end

  def get_all_client_cards(user_token_list)
    cards = []
    user_token_list.each do |user_token|
      current_card = retrieve_cards_by_user_token(user_token)
      if current_card['count'] == 0
        next
      end
      cards.push([current_card['data'][0]['last_four'], current_card['data'][0]['token']])
    end
    cards
  end

  def prepare_cards_dropdown(cards)
    return [] if cards['count'] == 0
    cards['data'].map do |card|
      card_balance = Card.get_balance(card['token'], current_store.token)
      cp_name = CardProduct.where(token: card['card_product_token']).to_a[0]['name']
      ["#{cp_name} ending in #{card['last_four']} with balance $#{card_balance['available_balance']}", card['token']]
    end
  end

  def retrieve_cards_by_user_token(user_token)
    User.get_request("https://shared-sandbox-api.marqeta.com/v3/cards/user/#{user_token}").parsed_response
  end

  private
    helper_method :get_full_name
    helper_method :get_client_cards
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
