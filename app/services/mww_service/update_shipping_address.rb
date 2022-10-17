module MWWService
  class UpdateShippingAddress
    attr_reader :shipping_address
    attr_reader :mww_shipping_address_id

    def self.call(shipping_address)
      new(shipping_address).call
    end

    def initialize(shipping_address)
      vendor_po = shipping_address.order.vendor_purchase_order_number
      @mww_shipping_address_id = MWWService::GetShippingAddressId.call(vendor_po)
      @shipping_address = shipping_address
    end

    def call
      response = http.request(request)

      return { status: true, message: "Successfully updated" } if response.code == '200'
      return { status: true, message: "The request has been accepted for processing, but the processing has not been completed." } if response.code == '202'
      return { status: true, message: "Not been modified since last request." } if response.code == '304'

      { status: false, message: parse_errors(response) }
    end

    private

    def url
      URI("#{ENV['URL']}/#{mww_shipping_address_id}")
    end

    def http
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http
    end

    def request
      Net::HTTP::Patch.new(url).tap do |req|
        req['Accept'] = 'application/vnd.api+json; version=1'
        req['Authorization'] = "auth-key=#{Rails.application.credentials[:mww][:auth_key]}"
        req['Content-Type'] = 'application/vnd.api+json'
        req.body = generate_payload(shipping_address)
      end
    end

    def parse_errors(response)
      return "You made a bad request" if response.blank?

      errors = JSON.parse(response.body)['errors'].map do |error|
        "Error code: #{error['code']}, #{error['title']} Details: #{error['detail']}"
      end.join(". ")

      errors
    end

    def generate_payload(shipping_address)
      {
        'data': {
          'id': mww_shipping_address_id,
          'type': 'shipping-addresses',
          'attributes': {
            'name': shipping_address.name,
            'address1': shipping_address.address1,
            'address2': shipping_address.address2,
            'city': shipping_address.city,
            'state': shipping_address.state,
            'postal-code':  shipping_address.postal_code,
            'country': shipping_address.country,
            'phone': shipping_address.phone,
            'email': shipping_address.email
          }
        }
      }.to_json
    end
  end
end
