require 'api_module'
class Store < ApplicationRecord
  include ApiModule

  # TODO: adjust schema to only contain necessary info (all models)

  # TODO: change store model/table to contain:
  # has_many to has_many user association (client model?)
  # confirm password field

  has_many :users
  has_many :clients
  validates :username, uniqueness: { case_sensitive: true }
  validates :name, presence: true, length: { maximum: 50 }
  has_secure_password

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
