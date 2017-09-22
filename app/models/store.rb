require 'httparty'
class Store < ApplicationRecord
  include HTTParty

  has_many :user
  validates :username, uniqueness: { case_sensitive: true }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :contact_email, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password


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
