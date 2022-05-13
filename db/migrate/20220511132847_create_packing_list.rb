class CreatePackingList < ActiveRecord::Migration[7.0]
  def change
    create_table :packing_lists do |t|
      t.string :url
      t.integer :packing_list_type, default: 0
      t.references :order, foreign_key: true, index: true

      t.timestamps
    end
  end
end
