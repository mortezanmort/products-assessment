ActiveAdmin.register Address do
  belongs_to :order
  navigation_menu :order

  permit_params :name, :address1, :address2, :city, :state, :country, :email, :phone, :address_type, :order_id, :postal_code, :address_type

  preserve_default_filters!
  remove_filter :order, :created_at, :updated_at, :address1, :address2
  filter :address_type_eq, as: :select, collection: Address.address_types, label: 'Type'

  action_item :update_addresses_to_mww, only: :index do
    link_to 'Update Addresses To MWW', update_order_addresses_path(order)
  end

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

  controller do
    def update_order_addresses
      order = Order.find_by(id: params[:id])

      if order.shipping_address.present?
        update_shipping_address(order)
      else
        redirect_to admin_order_addresses_path(order), alert: 'Error updating addresses.'
      end
    end

    private

    def update_shipping_address(order)
      response = MWWService::UpdateShippingAddress.call(order.shipping_address)

      if response[:status] && order.shipping_address.update(submission_errors: nil)
        flash[:notice] = response[:message]
      else
        order.shipping_address.update(submission_errors: response[:message])
        flash[:alert] = response[:message]
      end
      redirect_to admin_order_addresses_path(order)
    end
  end
end
