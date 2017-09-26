require 'api_module'
class Store < ApplicationRecord
  include ApiModule

  # TODO: change store model/table to contain:
  # has_many to has_many user association (client model?)
  # confirm password field

  has_many :user
  validates :username, uniqueness: { case_sensitive: true }
  validates :name, presence: true, length: { maximum: 50 }
  has_secure_password

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
