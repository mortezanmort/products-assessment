module MWWService
  class SubmitOrder
    attr_reader :order

    URL = URI(ENV['URL'])

    def self.call(order)
      new(order).call
    end

    def initialize(order)
      @order = order
    end

    def call
      response = http.request(request)
      return { status: true, message: "Successfully submitted" } if response.code == '201'

      { status: false, message: parse_errors_and_send_mail(response) }
    end

    private

    def http
      http = Net::HTTP.new(URL.host, URL.port)
      http.use_ssl = true
      http
    end

    def request
      req = Net::HTTP::Post.new(URL)
      req['Accept'] = 'application/vnd.api+json; version=1'
      req['Authorization'] = "auth-key=#{Rails.application.credentials[:mww][:auth_key]}"
      req['Content-Type'] = 'application/vnd.api+json'
      req.body = MWWService::GenerateOrderPayload.call(order)
      req
    end

    def parse_errors_and_send_mail(response)
      return "You made a bad request" if response.blank?

      errors = JSON.parse(response.body)['errors'].map do |error|
        "Error code: #{error['code']}, #{error['title']} Details: #{error['detail']}"
      end.join(". ")
      order.update(submission_errors: errors)
      order.send_error_email

      errors
    end
  end
end
