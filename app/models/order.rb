class Order < ApplicationRecord
  has_many :packing_lists, dependent: :destroy
  has_many :shipping_labels, dependent: :destroy
  has_many :line_items, dependent: :destroy
  has_many :addresses, dependent: :destroy

  has_paper_trail

  validates :vendor_purchase_order_number, presence: true

  enum status: { pending: 0, completed: 1, approved: 2, rejected: 3 , submitted: 4}

  def billing_address
    addresses.find_by(address_type: :billing_address)
  end

  def shipping_address
    addresses.find_by(address_type: :shipping_address)
  end
end
