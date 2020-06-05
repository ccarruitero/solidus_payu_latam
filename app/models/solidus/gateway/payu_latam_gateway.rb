# frozen_string_literal: true

module Solidus
  class Gateway::PayuLatamGateway < ::Spree::PaymentMethod::CreditCard
    preference :merchant_id, :string
    preference :account_id, :string
    preference :api_login, :string
    preference :api_key, :string
    preference :payment_country, :string, default: 'PE'

    def gateway_class
      ActiveMerchant::Billing::PayuLatamGateway
    end

    def partial_name
      'payu_latam'
    end

    def authorize(amount, credit_card, gateway_options)
      cvv = credit_card.verification_value
      options = add_missing_fields(gateway_options, cvv)
      gateway.authorize(amount, credit_card, options)
    end

    def capture(amount, authorization, gateway_options)
      gateway.capture(amount, authorization, gateway_options)
    end

    def void(authorization, gateway_options)
      gateway.void(authorization, gateway_options)
    end

    def purchase(amount, credit_card, gateway_options)
      cvv = credit_card.verification_value
      options = add_missing_fields(gateway_options, cvv)
      gateway.purchase(amount, credit_card, options)
    end

    def credit(amount, authorization, gateway_options)
      gateway.refund(amount, authorization, gateway_options)
    end

    private

    def add_missing_fields(options, cvv)
      dni_number = options[:customer_document]
      options.merge(
        dni_number: dni_number,
        cvv: cvv
      )
    end
  end
end
