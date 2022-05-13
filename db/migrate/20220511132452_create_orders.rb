class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :sales_order_number, default: '', null: false
      t.string :vendor_purchase_order_number, default: '', null: false
      t.string :shipping_method
      t.string :shipping_account_number
      t.string :shipping_details
      t.integer :vendor, default: 0
      t.integer :status, default: 0
      t.boolean :test_order, default: false
      t.text :notes, array: true, default: []
      t.datetime :netsuite_updated_at
      t.datetime :vendor_updated_at

      t.timestamps
    end
  end
end
