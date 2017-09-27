class Client < ApplicationRecord
  has_many :card
  
  def full_name(user_token)
    response = User.get_request("https://shared-sandbox-api.marqeta.com/v3/users/#{user_token}")
    user_data = response.parsed_response
    return user_data['first_name'] + user_data['last_name']
  end
end
