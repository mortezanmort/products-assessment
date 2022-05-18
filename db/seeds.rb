# frozen_string_literal: true

puts 'Beginning seed'

5.times do |i|
  User.create(first_name: 'Test', last_name: "Admin+#{i + 1}", username: "testadmin+#{i + 1}", email: "testadmin+#{i + 1}@test.com", password: 'Test123$')
end
puts 'Users created'

5.times do
  order = Order.create(sales_order_number: Faker::Alphanumeric.alphanumeric(number: 6), vendor_purchase_order_number: Faker::Alphanumeric.alphanumeric(number: 6))

  5.times do
    order.line_items.create(name: Faker::Commerce.product_name, quantity: rand(1..10))
  end

  5.times do
    order.addresses.create(email: Faker::Internet.email, address1: Faker::Address.full_address, city: Faker::Address.city, state: Faker::Address.state, country: Faker::Address.country)
  end

  order.packing_lists.create(url: Faker::Internet.url)

  order.shipping_labels.create(url: Faker::Internet.url)
end
puts 'Orders created'

puts 'Seed completed'
