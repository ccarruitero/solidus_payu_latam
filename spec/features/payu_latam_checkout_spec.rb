require 'spec_helper'

describe 'Payu Latam checkout', :vcr, type: :feature do
  let(:zone) { create(:zone) }
  let(:country) { create(:country) }
  let(:product) { create(:product) }

  context 'with autocapture' do
    before do
      Spree::Config.set(auto_capture: true)
      setup_payu_latam_gateway
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
      fill_credit_card '4111 1111 1111 1111', '32144457'
      click_button 'Save and Continue'
      expect(page).to have_content('Your order has been processed successfully')
    end
  end

  context 'without autocapture' do
    before do
      Spree::Config.set(currency: 'PEN')
      setup_payu_latam_gateway
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

    context 'with valid payment', js: true do
      stub_authorization!

      before do
        sleep(5)
        # wait to payU.getPaymentMethods()
        fill_credit_card '4111 1111 1111 1111', '32144457'
        click_button 'Save and Continue'
      end

      it 'can process' do
        expect(page).to have_content('Your order has been processed successfully')
      end

      it 'capture payment' do
        sleep(5)
        visit spree.admin_order_payments_path(Spree::Order.last)
        sleep(3)
        click_icon(:capture)
        expect(page).to have_content("Payment Updated")
      end

      it "voids a payment" do
        sleep(5)
        visit spree.admin_order_payments_path(Spree::Order.last)
        sleep(3)
        click_icon(:void)
        expect(page).to have_content("Payment Updated")
      end
    end
  end
end
