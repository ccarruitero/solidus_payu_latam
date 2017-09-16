require 'spec_helper'

describe Spree::Order, type: :model do
  let(:order) { Spree::Order.new }

  it 'has customer document attribute' do
    document = '43920390'
    order.customer_document = document
    expect(order.customer_document).to eq(document)
  end
end
