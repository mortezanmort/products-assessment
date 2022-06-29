class ReceiveOrderWorker
  include Sidekiq::Worker

  def perform
    NetSuiteService::FetchOrdersService.call
  end
end
