# frozen_string_literal: true

module PermittedAttributesDecorator
  Spree::PermittedAttributes.singleton_class.prepend SolidusPayuLatam::PermittedAttributesConcern
end
