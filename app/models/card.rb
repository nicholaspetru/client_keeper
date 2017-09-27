require 'api_module'
class Card < ApplicationRecord
  include ApiModule

  belongs_to :card_product
  belongs_to :user
  belongs_to :client

  def self.get_request(request_url)
    ApiModule.api_get_request(request_url)
  end

  def self.post_request(request_url, body=false)
    ApiModule.api_post_request(request_url, body)
  end

  def self.put_request(request_url, body=false)
    ApiModule.api_put_request(request_url, body)
  end
end
