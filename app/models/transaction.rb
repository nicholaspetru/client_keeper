require 'api_module'
class Transaction < ApplicationRecord
  include ApiModule

  belongs_to :card
  belongs_to :store
  belongs_to :user

  def self.make_request(request_url, body=false)
    ApiModule.api_request(request_url, body)
  end
end
