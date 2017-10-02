class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]


  def index
    @client = Client.find(params[:client_id])
    @user = retrieve_user_data(@client.user_token)
    @cards = Card.get_request("cards/user/#{@client.user_token}")
  end

  def show
    @client = Client.find(params[:id])
    @card = Card.get_request("cards/" + @user_token)
  end

  def new
    @card = Card.new
    @client = Client.find(params[:client_id])
    @user = User.get_request("users/#{@client.user_token}").parsed_response
    @card_products = CardProduct.all.map { |cp| [cp.name, cp.token] }
  end

  def edit
  end

  def create
    @card_products = CardProduct.all.map { |cp| [cp.name, cp.token] }
    @client = Client.find(params[:client_id])
    @user = User.get_request("users/#{@client.user_token}").parsed_response
    @body = {
      :user_token => @client.user_token,
      :card_product_token => params['card_product_token'],
      :fulfillment => {
        :shipping => {
          :recipient_address => {
            :first_name => @user['first_name'],
            :last_name => @user['last_name'],
            :address1 => @user['address1'],
            :city => @user['city'],
            :state => @user['state'],
            :zip => @user['zip']
          }
        }
      }
    }.to_json

    response = Card.post_request("cards/", @body)

    respond_to do |format|
      if response['error_code'].nil?
        success_redirect = "/clients/#{params[:client_id]}"
        flash[:success] = 'Card was successfully created. '
        find_funding_source(@client.user_token, response)
        format.html { redirect_to success_redirect }
        format.json { render :show, status: :created, location: success_redirect }
      else
        flash[:danger] = response['error_message']
        format.html { render :new }
        format.json { render json: response.error_code, status: :unprocessable_entity }
      end
    end
  end

  def add_funds
    @client = Client.find(params[:client_id])
    @card_data = retrieve_card_data(params['card_token'])
    @response = Card.add_funds(@client.user_token, params['amount'], params['card'])

    unless @response['error_code'].nil?
      flash[:danger] = @response['error_message']
    end
    redirect_to client_cards_path(@client)
  end

  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url, notice: 'Card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def retrieve_user_data(user_token)
    User.get_request("users/#{user_token}").parsed_response
  end

  def retrieve_card_data(card_token)
    Card.get_request("cards/#{card_token}").parsed_response
  end

  def find_funding_source(user_token, card_response)
    funding_source = Card.create_funding_source(user_token, card_response)
    if funding_source['error_code'].nil?
      flash[:success] += 'New funding source successfully established.'
    else
      flash[:danger] = funding_source['error_message']
    end
    funding_source
  end

  private
    def set_card
      @card = Card.find(params[:client_id])
    end

    def card_params
      params.require(:card).permit(:token, :user_token, :card_product_token, :status)
    end
end
