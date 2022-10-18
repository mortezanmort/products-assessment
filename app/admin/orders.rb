ActiveAdmin.register Order do
  permit_params :sales_order_number, :vendor_purchase_order_number, :shipping_method, :shipping_account_number, :vendor, :status, :test_order, :notes, :netsuite_updated_at, :vendor_updated_at

  remove_filter :packing_lists, :shipping_labels, :addresses, :versions, :line_items, :created_at, :updated_at, :submission_errors, :notes, :status
  preserve_default_filters!
  filter :status_eq, as: :select, collection: Order.statuses, label: 'Status'
  filter :vendor_eq, as: :select, collection: ['395 MWW On Demand'], label: 'Vendor'

  index do
    selectable_column
    column :id
    column :sales_order_number
    column :vendor_purchase_order_number
    column :shipping_method
    column :shipping_account_number
    column :vendor
    column 'status' do |order|
      div class: order.delayed? ? 'bg-red' : '' do
        order.status
      end
    end
    column :test_order
    column :notes
    column :submission_errors
    column :shipping_details
    column :netsuite_updated_at
    column :vendor_updated_at
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    inputs do
      input :sales_order_number
      input :vendor_purchase_order_number
      input :shipping_method
      input :shipping_account_number
      input :vendor
      input :status
      input :test_order
      input :notes
      input :netsuite_updated_at
      input :vendor_updated_at

      f.submit
    end
  end

  show do
    default_main_content
    div do
      if order.pending?
        link_to 'Approve', approve_order_path(order)
      else
        if order.submitted?
          div do
            'Submitted'
          end
        elsif order.vendor == '395 MWW On Demand'
          link_to 'Submit To MWW', submit_order_path(order)
        end
      end
    end
  end

  sidebar 'Orders', only: [:show, :edit] do
    ul do
      li link_to 'Line Items',    admin_order_line_items_path(resource)
      li link_to 'Addresses', admin_order_addresses_path(resource)
      li link_to 'Shipping Label', admin_order_shipping_labels_path(resource)
      li link_to 'Packing List', admin_order_packing_lists_path(resource)
    end
  end

  controller do
    def create
      order = Order.new(permitted_params[:order])
      order.notes = permitted_params.dig(:order, :notes)&.split

      if order.save
        redirect_to admin_order_path(order), notice: 'Order created successfully'
      else
        redirect_to new_admin_order_path, alert: order.errors
      end
    end

    def submit_order
      submission_details = MWWService::SubmitOrder.call(order)

      if submission_details[:status] && order.update(status: :submitted, submission_errors: nil)
        redirect_to admin_order_path(order), notice: submission_details[:message]
      else
        redirect_to admin_order_path(order), alert: submission_details[:message]
      end
    end

    def approve_order
      if order.pending? && order.approved!
        redirect_to admin_order_path(order), notice: 'Approved successfully'
      else
        redirect_to admin_order_path(order), alert: 'Something went wrong'
      end
    end

    private

    def order
      @_order ||= Order.find(params[:id])
    end
  end
end
