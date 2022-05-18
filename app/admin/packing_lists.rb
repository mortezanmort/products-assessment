ActiveAdmin.register PackingList do
  belongs_to :order
  navigation_menu :order

  permit_params :url, :packing_list_type, :order_id

  remove_filter :order

  form do |f|
    inputs do
      input :url
      input :packing_list_type
    end
    f.actions
  end
end
