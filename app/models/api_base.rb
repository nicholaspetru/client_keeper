class ApiBase < ApplicationRecord
  self.abstract_class = true

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
