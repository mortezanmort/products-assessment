class SubmitOrderWorker
  include Sidekiq::Worker

  def perform
    Order.approved.each do |order|
      MWWService::SubmitOrder.call(order)[:status] && order.submitted! || order.cancelled!
    end
  end
end
