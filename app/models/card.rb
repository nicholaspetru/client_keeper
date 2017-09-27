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

  def self.get_funding_source(user_token, card_response)
    funding_source = Card.get_request("#{@@base_url}fundingsources/user/#{user_token}")
    if funding_source["error_code"] == "404150"
      return {
        funding_source: Card.establish_funding_source(user_token, card_response),
        existing: false
      }
    else
      return {
        funding_source: funding_source['data'].first,
        existing: true
      }
    end
  end

  def self.establish_funding_source(user_token, card_response)
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
end
