class Order < ApplicationRecord
  has_many :packing_lists, dependent: :destroy
  has_many :shipping_labels, dependent: :destroy
  has_many :line_items, dependent: :destroy
  has_many :addresses, dependent: :destroy

  has_paper_trail

  validates :sales_order_number, :vendor_purchase_order_number, presence: true

  enum vendor: { mww: 0 }
end
