module MWWService
  class GetShippingAddressId
    attr_reader :vendor_po

    def self.call(vendor_po)
      new(vendor_po).call
    end

    def initialize(vendor_po)
      @vendor_po = vendor_po
    end

    def call
      response = http.request(request)
      return (JSON response.body)['data']['id'] if response.code == '200'

      false
    end

    private

    def url
      URI("#{ENV['URL']}/#{vendor_po}/shipping-address")
    end

    def http
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http
    end

    def request
      Net::HTTP::Get.new(url).tap do |req|
        req['Accept'] = 'application/vnd.api+json; version=1'
        req['Authorization'] = "auth-key=#{Rails.application.credentials[:mww][:auth_key]}"
        req['Content-Type'] = 'application/vnd.api+json'
      end
    end
  end
end
