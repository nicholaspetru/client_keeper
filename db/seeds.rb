# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

card_products_list = CardProduct.get_request("https://shared-sandbox-api.marqeta.com/v3/cardproducts?count=15
")

card_products_list['data'].each do |cp|
  CardProduct.create(name: cp['name'], token: cp['token'], active: cp['active'])
end
