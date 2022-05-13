class LineItem < ApplicationRecord
  belongs_to :order

  validates :name, presence: true
end
