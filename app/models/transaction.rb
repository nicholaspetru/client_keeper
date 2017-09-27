require 'api_module'
class Transaction < ApplicationRecord
  include ApiModule

  has_one :card
  has_one :store
  has_one :client
  has_one :user

  def full_name(user_token)
    response = User.get_request("https://shared-sandbox-api.marqeta.com/v3/users/#{user_token}")
    user_data = response.parsed_response
    return user_data['first_name'] + user_data['last_name']
  end

  def self.get_request(request_url)
    ApiModule.api_get_request(request_url)
  end

  def self.post_request(request_url, body=false)
    ApiModule.api_post_request(request_url, body)
  end
end
