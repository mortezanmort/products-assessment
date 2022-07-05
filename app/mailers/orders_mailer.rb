class OrdersMailer < ApplicationMailer
  before_action -> { @order = params[:order] }, only: %i[send_error_message]

  def send_error_message
    mail to: 'testemail1230@test.com'
  end
end
