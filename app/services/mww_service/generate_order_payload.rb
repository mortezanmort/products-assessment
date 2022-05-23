module MWWService
  class GenerateOrderPayload
    attr_reader :order

    def self.call(order)
      new(order).call
    end

    def initialize(order)
      @order = order
    end

    def call
      included_data = [get_addresses, get_line_item, get_packing_list, get_shipping_label].flatten
      {
        'data': {
          'type': 'orders',
          'attributes': {
            'vendor-po': order.vendor_purchase_order_number,
            'shipping-method':  order.shipping_method,
            'shipping-account-number': order.shipping_account_number,
            'test-order': order.test_order,
            'shipping-details': order.shipping_details
          }
        },
        'included': included_data
      }.to_json
    end

    private

    def get_addresses
      order.addresses.map do |address|
        {
          'type': 'shipping-address',
          'attributes': {
            'name': address.name,
            'address1': address.address1,
            'address2': address.address2,
            'city': address.city,
            'state': address.state,
            'country': address.country,
            'postal-code':  address.postal_code,
            'email': address.email,
            'phone': address.phone
          }
        }
      end
    end

    def get_line_item
      order.line_items.map do |line_item|
        {
          'type': 'line-items',
          'attributes': {
            'line-number': line_item.line_number,
            'quantity': line_item.quantity,
            'description': line_item.description,
            'product-code': line_item.product_code,
            'customer-product-code': line_item.customer_product_code,
            'item-properties': line_item.item_properties,
            'designs': line_item.designs
          }
        }
      end
    end

    def get_packing_list
      order.packing_lists.map do |packing_list|
        {
          'type': 'packing-list',
          'attributes': {
            'url': packing_list.url
          }
        }
      end
    end

    def get_shipping_label
      order.shipping_labels.map do |shipping_label|
        {
          'type': 'shipping-label',
          'attributes': {
            'url': shipping_label.url
          }
        }
      end
    end
  end
end
