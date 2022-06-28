NetSuite.configure do
  reset!
  account          Rails.application.credentials[:netsuite][:account]
  consumer_key     Rails.application.credentials[:netsuite][:consumer_key]
  consumer_secret  Rails.application.credentials[:netsuite][:consumer_secret]
  token_id         Rails.application.credentials[:netsuite][:token_id]
  token_secret     Rails.application.credentials[:netsuite][:token_secret]
  api_version      Rails.application.credentials[:netsuite][:api_version]
  wsdl_domain      Rails.application.credentials[:netsuite][:wsdl_domain]
  endpoint         "https://#{wsdl_domain}/services/NetSuitePort_#{api_version}"
  read_timeout      100_000
end
