require 'spec_helper'

describe 'Payu Latam checkout', type: :feature do
  let(:zone) { create(:zone) }
  let(:country) { create(:country) }
  let(:product) { create(:product) }
  let(:gateway) { setup_payu_latam_gateway }

  before do
    zone.members << Spree::ZoneMember.create!(zoneable: country)
    create(:store)
    create(:free_shipping_method)

    visit "/products/#{product.slug}"
    click_button 'Add To Cart'
    click_button 'Checkout'
    fill_in 'Customer E-Mail', with: 'han@example.com'
    within('#billing') { fill_address(country) }
    click_on 'Save and Continue'
    click_on 'Save and Continue'
  end

  it 'can process a valid payment', js: true do
    sleep(5)
    # wait to payU.getPaymentMethods()
    click_button 'Save and Continue'
    fill_credit_card '4242 4242 4242 4242', '78392838'
    click_button 'Place Order'
    expect(page).to have_content('Your order has been processed successfully')
  end
end
