require 'api_module'
class Card < ApplicationRecord
  include ApiModule

  belongs_to :card_product
  belongs_to :user
  has_many :transaction

  def self.make_request(request_url, body=false)
    ApiModule.api_request(request_url, body)
  end
end
