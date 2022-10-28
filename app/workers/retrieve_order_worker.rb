class RetrieveOrderWorker
  include Sidekiq::Worker

  def perform
    MWWService::RetrieveOrdersService.retrieve_orders
  end
end
