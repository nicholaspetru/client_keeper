require 'api_module'
class CardProduct < ApiBase
  include ApiModule

  has_many :card
end
