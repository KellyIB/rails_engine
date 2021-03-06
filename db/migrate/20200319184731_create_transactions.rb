class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :invoice, null: false, foreign_key: true
      t.bigint :credit_card_number
      t.integer :result, default: 0

      t.timestamps
    end
  end
end
