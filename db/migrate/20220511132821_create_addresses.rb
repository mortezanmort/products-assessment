class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :address1, default: ''
      t.string :address2
      t.string :city, default: ''
      t.string :state, default: ''
      t.string :country, default: ''
      t.string :email
      t.string :phone
      t.string :postal_code
      t.string :updation_errors, default: ''
      t.integer :address_type, default: 0
      t.references :order, foreign_key: true, index: true

      t.timestamps
    end
  end
end
