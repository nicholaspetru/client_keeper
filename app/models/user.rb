require 'api_module'
class User < ApiBase
  include ApiModule

  has_many :card

  def full_name
    "#{first_name} #{last_name}"
  end
end
