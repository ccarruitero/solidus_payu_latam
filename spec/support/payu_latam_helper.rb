module PayuLatamHelper
  def setup_payu_latam_gateway
    Spree::Config.set(auto_capture: true)

    Solidus::Gateway::PayuLatamGateway.create!(
      name: 'Payu Latam',
      preferred_merchant_id: '508029',
      preferred_account_id: '512323',
      preferred_api_login: 'pRRXKOl8ikMmt9u',
      preferred_api_key: '4Vj8eK4rloUd272L48hsrarnUA',
      preferred_public_key: 'PKaC6H4cEDJD919n705L544kSU'
    )
  end

  def fill_credit_card(number, document)
    fill_in 'Card Number', with: number, visible: false
    # Otherwise ccType field does not get updated correctly
    page.execute_script("$('.cardNumber').trigger('change')")
    fill_in 'Card Code', with: '123'
    fill_in 'Expiration', with: "01 / #{Time.now.year + 1}"
    fill_in 'customer_document', with: document
  end

  def fill_address(country)
    fill_in 'First Name', with: 'Han'
    fill_in 'Last Name', with: 'Solo'
    fill_in 'Street Address', with: 'YT-1300'
    fill_in 'City', with: 'Mos Eisley'
    select 'United States of America', from: 'Country'
    select country.states.first, from: 'order_bill_address_attributes_state_id'
    fill_in 'Zip', with: '12010'
    fill_in 'Phone', with: '(555) 555-5555'
  end
end
