# frozen_string_literal: true

module Solidus
  class Gateway::PayuLatamGateway < ::Spree::Gateway
    preference :merchant_id, :string
    preference :account_id, :string
    preference :api_login, :string
    preference :api_key, :string
    preference :payment_country, :string, default: 'PE'

    def provider_class
      ActiveMerchant::Billing::PayuLatamGateway
    end

    if SolidusSupport.solidus_gem_version < Gem::Version.new('2.3.x')
      def method_type
        'payu_latam'
      end
    else
      def partial_name
        'payu_latam'
      end
    end

    def authorize(amount, credit_card, gateway_options)
      cvv = credit_card.verification_value
      options = add_missing_fields(gateway_options, cvv)
      provider.authorize(amount, credit_card, options)
    end

    def capture(amount, authorization, gateway_options)
      provider.capture(amount, authorization, gateway_options)
    end

    def void(authorization, gateway_options)
      provider.void(authorization, gateway_options)
    end

    def purchase(amount, credit_card, gateway_options)
      cvv = credit_card.verification_value
      options = add_missing_fields(gateway_options, cvv)
      provider.purchase(amount, credit_card, options)
    end

    def credit(amount, authorization, gateway_options)
      provider.refund(amount, authorization, gateway_options)
    end

    private

    def add_missing_fields(options, cvv)
      dni_number = options[:customer_document]
      options.merge(
        buyer_email: options[:email],
        buyer_name: options[:shipping_address][:name],
        buyer_dni_number: dni_number,
        dni_number: dni_number,
        cvv: cvv
      )
    end
  end
end
