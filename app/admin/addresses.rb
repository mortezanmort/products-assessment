ActiveAdmin.register Address do
  belongs_to :order
  navigation_menu :order

  permit_params :name, :address1, :address2, :city, :state, :country, :email, :phone, :address_type, :order_id, :postal_code, :address_type

  preserve_default_filters!
  remove_filter :order, :created_at, :updated_at, :address1, :address2
  filter :address_type_eq, as: :select, collection: Address.address_types, label: 'Type'

  form do |f|
    inputs do
      input :name
      input :address1
      input :address2
      input :city
      input :state
      input :country
      input :postal_code
      input :email
      input :phone
      input :address_type
    end
    f.actions
  end
end
