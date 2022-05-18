ActiveAdmin.register Address do
  belongs_to :order
  navigation_menu :order

  permit_params :name, :address1, :address2, :city, :state, :country, :email, :phone, :address_type, :order_id

  remove_filter :order

  form do |f|
    inputs do
      input :name
      input :address1
      input :address2
      input :city
      input :state
      input :country
      input :email
      input :phone
      input :address_type
    end
    f.actions
  end
end
