module NetSuiteService
  class FetchOrdersService

    def self.call
      order_ids = purchase_orders.results.map(&:internal_id)
      return if order_ids.blank?

      orders = NetSuite::Records::PurchaseOrder.get_list(list: order_ids)
      NetSuiteService::CreateDBOrdersService.create_orders(orders)
    end

    private

    def self.purchase_orders
      NetSuite::Records::PurchaseOrder.search(
        criteria: {
          basic: [
            {
              field: 'type',
              operator: 'anyOf',
              value: ['_purchaseOrder'],
            },
            {
              field: 'tranDate',
              operator: 'within',
              type: 'SearchDateField',
              value: [
                Time.parse((Time.current - 30.days).to_s).iso8601,
                Time.parse(Time.current.to_s).iso8601,
              ]
            }
          ],
        },
      )
    end
  end
end
