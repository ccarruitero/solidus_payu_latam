# frozen_string_literal: true

module PaymentDecorator
  Spree::Payment.include SolidusPayuLatam::InjectCustomerDocumentConcern
end
