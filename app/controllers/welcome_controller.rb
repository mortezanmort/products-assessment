class WelcomeController < ApplicationController
  def index
  end

  def fetch_netsuite_orders
    orders = NetSuiteService::FetchOrdersService.call
    redirect_to admin_orders_path
  end
end
