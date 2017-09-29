require 'api_module'
class User < ApplicationRecord
  include ApiModule

  has_many :card

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.get_request(endpoint)
    ApiModule.api_get_request(endpoint)
  end

  def self.post_request(endpoint, body=false)
    ApiModule.api_post_request(endpoint, body)
  end

  def self.put_request(endpoint, body=false)
    ApiModule.api_put_request(endpoint, body)
  end
end
