# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

store_list = Store.make_request("https://shared-sandbox-api.marqeta.com/v3/stores?count=25&sort_by=-lastModifiedTime
")

store_list['data'].each do |store|
  Store.create(name: store['name'], token: store['token'], active: store['active'], contact_email: store['contact_email'])
end
