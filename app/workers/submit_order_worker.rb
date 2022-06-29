class SubmitOrderWorker
  include Sidekiq::Worker

  def perform
    Order.vendor_approved_orders('395 MWW On Demand').each do |order|
      MWWService::SubmitOrder.call(order)[:status] && order.submitted! || order.cancelled!
    end
  end
end
