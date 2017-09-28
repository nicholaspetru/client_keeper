require 'api_module'
class CardProduct < ApplicationRecord
  include ApiModule

  has_many :card

  def self.get_request(request_url)
    ApiModule.api_get_request(request_url)
  end
end
