class Client < ApplicationRecord
  has_many :card

  @@card_transition_base_url = "https://shared-sandbox-api.marqeta.com/v3/cardtransitions"

  def self.post_card_transitions(body=false, url=@@card_transition_base_url)
    puts "CTBOD: #{body}"
    ApiModule.api_post_request(url, body)
  end
end
#cardholder_balance
