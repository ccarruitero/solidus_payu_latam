class AddCustomerDocumentToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_orders, :customer_document, :string
  end
end
