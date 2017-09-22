require 'httparty'
class User < ApplicationRecord
  include HTTParty

  has_many :card
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  @@application_token = 'user19081505171746'
  @@master_token = '246476e0-cc3a-4994-9868-57a3ce6ace53'

  def self.make_request(request_url, body=false)
    @body = body
    return HTTParty.get(request_url, {
      :body => @body,
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
