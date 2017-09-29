require 'api_module'
class CardProduct < ApplicationRecord
  include ApiModule

  has_many :card

  def self.get_request(endpoint)
    ApiModule.api_get_request(endpoint)
  end
end
