module MWWService
  class RetrieveOrdersService

    def self.retrieve_orders
      new.retrieve_orders
    end

    def retrieve_orders
      Order.submitted.each do |order|
        @URL = URI(ENV['MWW_URL'] + '/' + order.vendor_purchase_order_number)
        response = http.request(request)
        update_order(order, response) if response&.code == '200'
      end
    end

    private

    def http
      http = Net::HTTP.new(@URL.host, @URL.port)
      http.use_ssl = true
      http
    end

    def request
      req = Net::HTTP::Get.new(@URL)
      req['Accept'] = 'application/vnd.api+json; version=1'
      req['Authorization'] = "auth-key=#{Rails.application.credentials[:mww][:auth_key]}"
      req['Content-Type'] = 'application/vnd.api+json'
      req
    end

    def update_order(order, response)
      mww_order = JSON.parse(response.body)['data']
      order.vendor_updated_at = mww_order['attributes']['updated-at']
      order.status = mww_order['attributes']['state'] if mww_order['attributes']['state'] == 'shipped'
      # TODO update tracking number of order when it's available
      order.save
    end
  end
end
