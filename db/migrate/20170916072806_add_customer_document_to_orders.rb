class AddCustomerDocumentToOrders < SolidusSupport::Migration[4.2]
  def change
    add_column :spree_orders, :customer_document, :string
  end
end
