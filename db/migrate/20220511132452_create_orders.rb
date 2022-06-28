class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :sales_order_number
      t.string :vendor_purchase_order_number, default: '', null: false
      t.string :shipping_method
      t.string :shipping_account_number
      t.string :test_order, default: 'test', null: false
      t.string :vendor, default: ''
      t.integer :status, default: 0
      t.text :notes, array: true, default: []
      t.jsonb :shipping_details
      t.datetime :netsuite_updated_at
      t.datetime :vendor_updated_at

      t.timestamps
    end
  end
end
