require 'api_module'
class CardProduct < ApplicationRecord
  include ApiModule

  has_many :card

  def self.get_request(request_url, body=false)
    ApiModule.api_get_request(request_url, body)
  end
end
