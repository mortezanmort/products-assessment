module NetSuiteService
  class CreateDBOrdersService
    attr_reader :order

    def self.create_orders(purchase_orders)
      new.create_orders(purchase_orders)
    end

    def create_orders(purchase_orders)
      purchase_orders.each do |purchase_order|
        if order_present?(purchase_order)
          update_existing_order(purchase_order) if order_changed?(purchase_order)
        else
          create_order(purchase_order)
        end
      end
    end

    private

    def create_order(purchase_order)
      @order = Order.new(
        sales_order_number: purchase_order.created_from.attributes[:name],
        vendor_purchase_order_number: purchase_order.tran_id,
        vendor: purchase_order.entity.attributes[:name],
        shipping_method: purchase_order.ship_method.attributes[:name],
        shipping_details: {
          purchase_order: purchase_order.ship_date,
          ship_is_residential: purchase_order.ship_is_residential,
          descreption: purchase_order.attributes[:custom_field_list].custom_fields.last.attributes[:value]
        },
        test_order: ENV['TEST_ORDER'],
        netsuite_updated_at: purchase_order.last_modified_date
      )

      JSON.parse(purchase_order.attributes[:item_list].to_json)['list'].each do |item|
        initialize_line_item(item)
      end

      initialize_billing_address(purchase_order)
      initialize_shipping_address(purchase_order) if purchase_order.shipping_address.present?

      order.save
    end

    def update_existing_order(purchase_order)
      update_line_items(purchase_order)
      update_billing_address(purchase_order)
      update_shipping_address(purchase_order)
      update_order(purchase_order)
    end

    def update_order(purchase_order)
      order.sales_order_number = purchase_order.created_from.attributes[:name],
      order.vendor_purchase_order_number = purchase_order.tran_id
      order.vendor = purchase_order.entity.attributes[:name]
      order.shipping_method = purchase_order.ship_method.attributes[:name]
      order.shipping_details = {
        purchase_order: purchase_order.ship_date,
        ship_is_residential: purchase_order.ship_is_residential,
        descreption: purchase_order.attributes[:custom_field_list].custom_fields.last.attributes[:value]
      }
      order.test_order = ENV['TEST_ORDER']
      order.netsuite_updated_at = purchase_order.last_modified_date
    end

    def update_line_items(purchase_order)
      order.line_items.delete_all
      JSON.parse(purchase_order.attributes[:item_list].to_json)['list'].each do |item|
        initialize_line_item(item)
        order.save
      end
    end

    def update_billing_address(purchase_order)
      if (address = order.billing_address).present?
        address.name = purchase_order.billing_address.attributes[:addressee]
        address.address1 = purchase_order.billing_address.attributes[:addr1]
        address.address2 = purchase_order.billing_address.attributes[:addr2]
        address.city = purchase_order.billing_address.attributes[:city]
        address.state = purchase_order.billing_address.attributes[:state]
        address.country = JSON.parse(purchase_order.billing_address.country.to_json)["id"]&.[](1..-1)&.humanize
        address.postal_code = purchase_order.billing_address.attributes[:zip]
        address.save
      elsif purchase_order.billing_address.present?
        initialize_billing_address(purchase_order)
        order.save
      elsif purchase_order.billing_address.empty?
        order.addresses.find_by(address_type: :billing_address)&.destroy
      end
    end

    def update_shipping_address(purchase_order)
      if (address = order.shipping_address).present?
        address.name =  purchase_order.shipping_address.attributes[:addressee]
        address.address1 = purchase_order.shipping_address.attributes[:addr1]
        address.address2 = purchase_order.shipping_address.attributes[:addr2]
        address.city = purchase_order.shipping_address.attributes[:city]
        address.state = purchase_order.shipping_address.attributes[:state]
        address.country = JSON.parse(purchase_order.shipping_address.country.to_json)["id"]&.[](1..-1)&.humanize,
        address.postal_code = purchase_order.shipping_address.attributes[:zip]
        address.save
      elsif purchase_order.shipping_address.present?
        initialize_shipping_address(purchase_order)
        order.save
      elsif purchase_order.shipping_address.empty?
        order.addresses.find_by(address_type: :shipping_address)&.destroy
      end
    end

    def initialize_line_item(item)
      order.line_items.new(
        name: item.dig("attributes", "item", "attributes", "name"),
        description: item.dig("attributes", "description"),
        line_number: item.dig("attributes", "line"),
        quantity: item.dig("attributes", "quantity"),
        product_code: item.dig("attributes", "vendor_name"),
        customer_product_code: item.dig("attributes", "vendor_name"),
        netsuite_updated_at: Time.current,
        image_remote_url: fetch_url(item)
      )
    end

    def initialize_billing_address(purchase_order)
      order.addresses.new(
        address_type: :billing_address,
        name: purchase_order.billing_address.attributes[:addressee],
        address1: purchase_order.billing_address.attributes[:addr1],
        address2: purchase_order.billing_address.attributes[:addr2],
        city: purchase_order.billing_address.attributes[:city],
        state: purchase_order.billing_address.attributes[:state],
        country: JSON.parse(purchase_order.billing_address.country.to_json)["id"]&.[](1..-1)&.humanize,
        postal_code: purchase_order.billing_address.attributes[:zip]
      )
    end

    def initialize_shipping_address(purchase_order)
      order.addresses.new(
        address_type: :shipping_address,
        name: purchase_order.shipping_address.attributes[:addressee],
        address1: purchase_order.shipping_address.attributes[:addr1],
        address2: purchase_order.shipping_address.attributes[:addr2],
        city: purchase_order.shipping_address.attributes[:city],
        state: purchase_order.shipping_address.attributes[:state],
        country: JSON.parse(purchase_order.shipping_address.country.to_json)["id"]&.[](1..-1)&.humanize,
        postal_code: purchase_order.shipping_address.attributes[:zip]
      )
    end

    def order_present?(purchase_order)
      @order = Order.pending.find_by(vendor_purchase_order_number: purchase_order.tran_id)
      @order.present?
    end

    def order_changed?(purchase_order)
      purchase_order.last_modified_date > order.netsuite_updated_at
    end

    def fetch_url(item)
      url = nil
      item.dig('attributes', 'custom_field_list', 'custom_fields').each do |script|
        url = script['attributes']['value'] if script['script_id'] == 'custcol_bb_art_link'
      end
      url
    end
  end
end
