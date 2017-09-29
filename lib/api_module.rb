require 'httparty'
module ApiModule
  include HTTParty

  def self.api_get_request(endpoint)
    request_url = ENV['BASE_URL'] + endpoint
    return HTTParty.get(request_url, {
      :basic_auth => {
        :username => ENV['APPLICATION_TOKEN'],
        :password => ENV['MASTER_TOKEN']
      },
      :headers => {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    })
  end

  def self.api_post_request(endpoint, body=false)
    request_url = ENV['BASE_URL'] + endpoint
    @body = body
    return HTTParty.post(request_url, {
      :body => @body,
      :basic_auth => {
        :username => ENV['APPLICATION_TOKEN'],
        :password => ENV['MASTER_TOKEN']
      },
      :headers => {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    })
  end

  def self.api_put_request(endpoint, body=false)
    request_url = ENV['BASE_URL'] + endpoint
    @body = body
    return HTTParty.put(request_url, {
      :body => @body,
      :basic_auth => {
        :username => ENV['APPLICATION_TOKEN'],
        :password => ENV['MASTER_TOKEN']
      },
      :headers => {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    })
  end
end
