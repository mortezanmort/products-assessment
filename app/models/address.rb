class Address < ApplicationRecord
  belongs_to :order

  enum address_type: { billing_address: 0, shipping_address: 1 }
end
