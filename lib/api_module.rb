require 'httparty'
module ApiModule
  include HTTParty

  @@application_token = 'user19081505171746'
  @@master_token = '246476e0-cc3a-4994-9868-57a3ce6ace53'

  def self.api_get_request(request_url)
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

  def self.api_post_request(request_url, body=false)
    @body = body
    return HTTParty.post(request_url, {
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

  def self.api_put_request(request_url, body=false)
    @body = body
    return HTTParty.put(request_url, {
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
