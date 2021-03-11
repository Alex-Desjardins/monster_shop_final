# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

user = User.create!(
  name: 'Billy Joel',
  address: '123 Song St.',
  city: 'Las Vegas',
  state: 'NV',
  zip: '12345',
  email: 'user@user.com',
  password: '123',
  role: 0)

merchant = User.create!(
  name: 'Joel Billy',
  address: '321 Lyric St.',
  city: 'Miami',
  state: 'FL',
  zip: '12345',
  email: 'merchant@user.com',
  password: '123',
  merchant_id: megan.id,
  role: 1)

admin = User.create!(
  name: "Dr. Dre",
  address: "543 Bunker Ave.",
  city: "Detroit",
  state: "MI",
  zip: "98765",
  email: "admin@user.com",
  password: "123",
  role: 2)

discount_1 = megan.discounts.create!(percentage: 5, item_amount: 5)
discount_2 = megan.discounts.create!(percentage: 10, item_amount: 5)
discount_3 = megan.discounts.create!(percentage: 15, item_amount: 10)

discount_4 = brian.discounts.create!(percentage: 5, item_amount: 5)
discount_5 = brian.discounts.create!(percentage: 10, item_amount: 10)



megan.items.create!(name: 'Ogre', description: "Large, green, and smells like onions.", price: 20, image: 'https://www.youngupstarts.com/wp-content/uploads/2013/11/Shrek_fierce.jpg', active: true, inventory: 10 )
megan.items.create!(name: 'Dragon', description: "Huge with large claws and stinky breath.", price: 50, image: 'https://i.dlpng.com/static/png/6423653_preview.png', active: true, inventory: 15 )
brian.items.create!(name: 'Frankenstein', description: "Conglomerate of 4 dead humans in 1 body.", price: 50, image: 'https://m.media-amazon.com/images/I/511-U5qn5bL._AC_SL1000_.jpg', active: true, inventory: 20 )
