class Order < ApplicationRecord
  has_one :packing_list
  has_one :shipping_label
  has_many :line_items
  has_many :addresses

  has_paper_trail

  validates :sales_order_number, :vendor_purchase_order_number, presence: true
end
