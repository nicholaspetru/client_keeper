require 'api_module'
class User < ApplicationRecord
  include ApiModule

  has_many :card

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.get_request(request_url)
    puts request_url
    ApiModule.api_get_request(request_url)
  end

  def self.post_request(request_url, body=false)
    ApiModule.api_post_request(request_url, body)
  end

  def self.put_request(request_url, body=false)
    ApiModule.api_put_request(request_url, body)
  end
end
