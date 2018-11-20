# frozen_string_literal: true

Spree::PermittedAttributes.singleton_class.prepend SolidusPayuLatam::PermittedAttributesConcern
