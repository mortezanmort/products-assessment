ActiveAdmin.register ShippingLabel do
  belongs_to :order
  navigation_menu :order

  permit_params :url, :shipping_label_attributes, :order_id

  remove_filter :order

  form do |f|
    inputs do
      input :url
      input :shipping_label_attributes
    end
    f.actions
  end
end
