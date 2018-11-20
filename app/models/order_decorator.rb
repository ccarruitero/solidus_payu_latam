# frozen_string_literal: true

Spree::Order.class_eval do
  checkout_flow do
    go_to_state :address
    go_to_state :delivery
    go_to_state :payment
    go_to_state :complete
  end

  state_machine do
    event :payment_failed do
      reset
      transition payment: :payment
    end
  end
end
