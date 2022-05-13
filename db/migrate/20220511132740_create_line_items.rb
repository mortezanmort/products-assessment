class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.string :name, default: '', null: false
      t.string :description
      t.string :product_code
      t.string :customer_product_code
      t.string :image_remote_url
      t.string :location
      t.integer :line_number, default: 0
      t.integer :quantity, default: 0, null: false
      t.integer :placement, default: 0
      t.jsonb :item_properties
      t.text :designs, array: true, default: []
      t.datetime :vendor_updated_at
      t.datetime :netsuite_updated_at
      t.references :order, foreign_key: true, index: true

      t.timestamps
    end
  end
end
