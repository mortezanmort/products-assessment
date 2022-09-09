ActiveAdmin.register LineItem do
  belongs_to :order
  navigation_menu :order

  permit_params :name, :description, :product_code, :customer_product_code, :image_remote_url, :location, :line_number, :quantity, :placement, :item_properties, :designs, :vendor_updated_at, :netsuite_updated_at, :order_id

  remove_filter :order, :created_at, :updated_at, :designs, :image_remote_url, :description, :vendor_updated_at, :netsuite_updated_at

  index do
    instance_eval(&default_table)
    column 'Images' do |line_item|
      ("<a href=#{line_item.image_remote_url}>open image</a>").html_safe if line_item.image_remote_url.present?
    end
  end

  show do
    default_main_content

    attributes_table do
      row :image do |line_item|
        if line_item.image_remote_url.present?
          image_tag line_item.image_remote_url, class: 'img'
        end
      end
    end
  end

  form do |f|
    inputs do
      input :name
      input :description
      input :product_code
      input :customer_product_code
      input :image_remote_url
      input :location
      input :line_number
      input :quantity
      input :placement
      input :item_properties
      input :vendor_updated_at
      input :netsuite_updated_at
    end
    f.actions
  end
end
