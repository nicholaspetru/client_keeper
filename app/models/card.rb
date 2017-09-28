require 'api_module'
class Card < ApplicationRecord
  include ApiModule

  belongs_to :card_product
  belongs_to :user
  belongs_to :client

  @account_options = ['4112344112344113', '4110144110144115', '5111005111051128', '5112345112345114', '371144371144376', '341134113411347', '6011016011016011', '6559906559906557', '3566003566003566', '3528000000000007']
  @@base_url = "https://shared-sandbox-api.marqeta.com/v3/"

  def self.get_request(request_url)
    ApiModule.api_get_request(request_url)
  end

  def self.post_request(request_url, body=false)
    ApiModule.api_post_request(request_url, body)
  end

  def self.put_request(request_url, body=false)
    ApiModule.api_put_request(request_url, body)
  end

  def self.get_cvv(card_token)
    Card.get_request("#{@@base_url}cards/#{card_token}/showpan?show_cvv_number=true")
  end

  def self.get_balance(card_token, store_token)
    @store = Store.get_request("https://shared-sandbox-api.marqeta.com/v3/stores/#{store_token}")
    @body = {
      :card_token => card_token,
      :mid => @store['mid'],
      :account_type => 'credit'
    }.to_json
    response = Card.post_request("#{@@base_url}simulate/financial/balanceinquiry", @body)
    response['transaction']['gpa']
  end

  def self.add_funds(user_token, amount, card_data)
    funding_source_token = Card.create_funding_source(user_token, card_data)
    funding_source_address = Card.get_funding_source_address(user_token)
    @body = {
      :user_token => user_token,
      :amount => amount,
      :currency_code => 'USD',
      :funding_source_token => funding_source_token['token'],
      :funding_source_address_token => funding_source_address['token']
    }.to_json
    Card.post_request("#{@@base_url}gpaorders", @body)
  end

  def self.create_funding_source(user_token, card_response)
    card = Card.get_request("#{@@base_url}cards/user/#{user_token}")
    card = card['data'].first if card['count'] > 0

    cvv_response = Card.get_cvv(card['token'])

    @body = {
      :user_token => user_token,
      :account_number => @account_options[rand(@account_options.length)],
      :exp_date => card['expiration'],
      :cvv_number => cvv_response['cvv_number']
    }.to_json

    Card.post_request("#{@@base_url}/fundingsources/paymentcard", @body)
  end

  def self.get_funding_source_address(user_token)
      funding_adddress_response = Card.get_request("#{@@base_url}fundingsources/addresses/user/#{user_token}")
      if funding_adddress_response['error_code'].nil?
        funding_adddress_response
      else
        Card.set_funding_source_address(user_token)
      end
  end

  def self.set_funding_source_address(user_token)
    user = User.get_request("#{@@base_url}/users/#{user_token}")
    @body = {
      :user_token => user_token,
      :first_name => user['first_name'],
      :last_name => user['last_name'],
      :address_1 => user['address1'],
      :city => user['city'],
      :state => user['state'],
      :zip => user['zip'],
      :country => "USA"
    }.to_json
    Card.post_request("#{@@base_url}fundingsources/addresses", @body)
  end
end
