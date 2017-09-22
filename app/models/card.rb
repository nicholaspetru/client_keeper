require 'httparty'
class Card < ApplicationRecord
  include HTTParty

  belongs_to :card_product
  belongs_to :user
  has_many :transaction

  @@application_token = 'user19081505171746'
  @@master_token = '246476e0-cc3a-4994-9868-57a3ce6ace53'

  #TODO: provide generic make_request method in application_record.rb?

  def self.make_request(request_url)
    return HTTParty.get(request_url, {
      :basic_auth => {
        :username => @@application_token,
        :password => @@master_token
      },
      :headers => {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    })
  end
end
