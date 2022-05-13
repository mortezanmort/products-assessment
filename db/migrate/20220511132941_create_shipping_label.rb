class CreateShippingLabel < ActiveRecord::Migration[7.0]
  def change
    create_table :shipping_labels do |t|
      t.string :url
      t.jsonb :shipping_label_attributes
      t.references :order, foreign_key: true, index: true

      t.timestamps
    end
  end
end
