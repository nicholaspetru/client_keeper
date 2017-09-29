require 'api_module'
class Transaction < ApiBase
  include ApiModule

  has_one :card
  has_one :store
  has_one :client
  has_one :user

  def full_name(user_token)
    response = User.get_request("users/#{user_token}")
    user_data = response.parsed_response
    return user_data['first_name'] + user_data['last_name']
  end
end
