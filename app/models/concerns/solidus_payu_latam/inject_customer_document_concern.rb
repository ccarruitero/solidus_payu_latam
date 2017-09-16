module SolidusPayuLatam
  module InjectCustomerDocumentConcern
    extend ActiveSupport::Concern
    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def gateway_options
        options = super
        document = order.customer_document
        options[:customer_document] = document if document
        options
      end
    end
  end
end
