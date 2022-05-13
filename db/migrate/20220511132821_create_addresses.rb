class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :address1, default: '', null: false, limit: 250
      t.string :address2, limit: 250
      t.string :city, default: '', null: false
      t.string :state, default: '', null: false
      t.string :country, default: '', null: false
      t.string :email
      t.string :phone
      t.integer :address_type, default: 0
      t.references :order, foreign_key: true, index: true

      t.timestamps
    end
  end
end
