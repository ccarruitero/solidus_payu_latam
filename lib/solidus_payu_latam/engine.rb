# frozen_string_literal: true

module SolidusPayuLatam
  class Engine < Rails::Engine
    engine_name 'solidus_payu_latam'

    if SolidusSupport.backend_available?
      paths['app/views'] << 'lib/views/backend'
    end

    if SolidusSupport.frontend_available?
      paths['app/views'] << 'lib/views/frontend'
    end

    initializer 'spree.gateway.payment_methods', after: 'spree.register.payment_methods' do |app|
      app.config.spree.payment_methods << Solidus::Gateway::PayuLatamGateway
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')).sort.map do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
