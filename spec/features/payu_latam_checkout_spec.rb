# frozen_string_literal: true

require 'spec_helper'

describe 'Payu Latam checkout', :vcr, type: :feature do
  let(:zone) { create(:zone) }
  let(:country) { create(:country) }
  let(:product) { create(:product) }

  before do
    config = { currency: 'PEN' }

    if Spree.solidus_gem_version >= Gem::Version.new('2.9')
      config.merge!(use_combined_first_and_last_name_in_address: false)
    end

    stub_preferences(config)
  end

  context 'with autocapture' do
    before do
      stub_preferences(auto_capture: true)
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
      fill_credit_card '4111 1111 1111 1111', '32144457'
      click_button 'Save and Continue'
      expect(page).to have_content('Your order has been processed successfully')
    end
  end

  context 'without autocapture' do
    before do
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
        fill_credit_card '4111 1111 1111 1111', '32144457'
        click_button 'Save and Continue'
      end

      it 'can process' do
        expect(page).to have_content('Your order has been processed successfully')
      end

      it 'capture payment' do
        visit spree.admin_order_payments_path(Spree::Order.last)
        click_icon(:capture)
        expect(page).to have_content('Payment Updated')
      end

      it 'voids a payment' do
        visit spree.admin_order_payments_path(Spree::Order.last)
        click_icon(:capture)
        click_icon(:void)
        expect(page).to have_content('Payment Updated')
      end
    end
  end
end
