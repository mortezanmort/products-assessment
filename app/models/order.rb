class Order < ApplicationRecord
  has_many :packing_lists
  has_many :shipping_labels
  has_many :line_items
  has_many :addresses

  has_paper_trail

  validates :sales_order_number, :vendor_purchase_order_number, presence: true

  enum vendor: { mww: 0 }
end
