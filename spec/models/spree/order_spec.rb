# frozen_string_literal: true

require 'spec_helper'

describe Spree::Order, type: :model do
  let(:order) { described_class.new }

  it 'has customer document attribute' do
    document = '43920390'
    order.customer_document = document
    expect(order.customer_document).to eq(document)
  end

  describe 'state_machine' do
    it 'dont have confirm state' do
      expect(described_class.checkout_steps.key?(:confirm)).to be(false)
    end

    context 'with payment_failed event' do
      let(:event) { described_class.state_machine.events[:payment_failed] }

      it 'not have confirm state' do
        expect(event.known_states.include?(:confirm)).to be(false)
      end

      it 'only have transition from/to payment' do
        expect(event.known_states).to eq([:payment])
      end
    end
  end
end
