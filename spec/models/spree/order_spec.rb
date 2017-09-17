require 'spec_helper'

describe Spree::Order, type: :model do
  let(:order) { Spree::Order.new }

  it 'has customer document attribute' do
    document = '43920390'
    order.customer_document = document
    expect(order.customer_document).to eq(document)
  end

  context 'state_machine' do
    it 'dont have confirm state' do
      expect(Spree::Order.checkout_steps.keys.include?(:confirm)).to be(false)
    end

    context 'payment_failed event' do
      it 'only have transition from complete' do
        event = Spree::Order.state_machine.events[:payment_failed]
        expect(event.known_states.include?(:confirm)).to be(false)
        expect(event.known_states).to eq([:payment])
      end
    end
  end
end
