# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV['ADMIN_EMAIL_ADDRESS']
  layout 'mailer'
end
