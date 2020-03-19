class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :merchant, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
