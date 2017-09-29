class Client < ApplicationRecord
  has_many :card

  def self.post_card_transitions(body=false, endpoint="cardtransitions")
    ApiModule.api_post_request(endpoint, body)
  end
end
#cardholder_balance
