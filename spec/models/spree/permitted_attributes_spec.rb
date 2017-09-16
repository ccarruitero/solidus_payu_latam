require 'spec_helper'

describe Spree::PermittedAttributes do
  let(:attributes) { described_class }

  context 'checkout_attributes' do
    it 'include customer_document' do
      expect(attributes.checkout_attributes).to include(:customer_document)
    end
  end
end
