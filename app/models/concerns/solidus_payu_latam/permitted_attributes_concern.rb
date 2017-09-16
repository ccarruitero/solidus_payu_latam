module SolidusPayuLatam
  module PermittedAttributesConcern
    def checkout_attributes
      super | [:customer_document]
    end
  end
end
