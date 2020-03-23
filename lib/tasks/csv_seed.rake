require 'csv'
require 'pry'
#rake task should:
# Clear your Development database to prevent data duplication
# Seed your Development database with the CSV data
# Be invokable through Rake, i.e. you should be able to run bundle exec rake <your_rake_task_name> from the command line
# Convert all prices before storing. Prices are in cents, therefore you will need to transform them to dollars. (12345 becomes 123.45)
# Reset the primary key sequence for each table you import so that new records will receive the next valid primary key.
#mod1 csv - futbol
# , header_converters: :symbol, converters: :all ?
desc "clear and seed development database, convert cents to dollars, and reset primary key sequence"
  task :csv_seed => [:environment] do
#db:reset or destroy_all/delete_all? system "rake db:reset"
    puts "Destroying all previous records.", ""

    # system "rake db:reset"
    #clear versus drop?
    Transaction.delete_all
    InvoiceItem.delete_all
    Invoice.delete_all
    Item.delete_all
    Merchant.delete_all
    Customer.delete_all

    puts "Resetting primary keys.", ""
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end

    puts "Reading customer data.", ""
    CSV.foreach("db/data/customers.csv", headers: true, header_converters: :symbol, converters: :all) do |row|
      Customer.create(row.to_h)
    end
    # next_value = (Customer.last.id + 1)
    next_value = (Customer.order(id: :desc).limit(1).pluck(:id)[0]) + 1
    ActiveRecord::Base.connection.execute("alter sequence customers_id_seq restart with #{next_value};")
    puts "Customers created.", ""

    puts "Reading merchant data.", ""
    CSV.foreach("db/data/merchants.csv", headers: true, header_converters: :symbol, converters: :all) do |row|
      Merchant.create(row.to_h)
    end
    # next_value = (Merchant.last.id + 1)
    next_value = (Merchant.order(id: :desc).limit(1).pluck(:id)[0]) + 1

    ActiveRecord::Base.connection.execute("alter sequence merchants_id_seq restart with #{next_value};")
    puts "Merchants created.", ""

    puts "Reading item data.", ""
    CSV.foreach("db/data/items.csv", headers: true, header_converters: :symbol, converters: :all) do |row|
      item_hash = row.to_h
      item_hash[:unit_price] = item_hash[:unit_price].to_f/100
      Item.create(item_hash)
    end
    # next_value = (Item.last.id + 1)
    next_value = (Item.order(id: :desc).limit(1).pluck(:id)[0]) + 1

    ActiveRecord::Base.connection.execute("alter sequence items_id_seq restart with #{next_value};")
    puts "Items created.", ""

     puts "Reading invoice data.", ""
    CSV.foreach("db/data/invoices.csv", headers: true, header_converters: :symbol, converters: :all) do |row|
      invoice_hash = row.to_h
      if invoice_hash[:status] == "shipped"
        invoice_hash[:status] = 1
      elsif invoice_hash[:status] == "pending"
        invoice_hash[:status] = 0
      elsif invoice_hash[:status] == "cancelled"
        invoice_hash[:status] = 2
      end
      Invoice.create(invoice_hash)
    end
    # next_value = (Invoice.last.id + 1)
    next_value = (Invoice.order(id: :desc).limit(1).pluck(:id)[0]) + 1
    ActiveRecord::Base.connection.execute("alter sequence invoices_id_seq restart with #{next_value};")
    puts "Invoices created.", ""

    puts "Reading invoice_items data.", ""
    CSV.foreach("db/data/invoice_items.csv", headers: true, header_converters: :symbol, converters: :all) do |row|
      invoice_item_hash = row.to_h
      invoice_item_hash[:unit_price] = invoice_item_hash[:unit_price].to_f/100
      InvoiceItem.create(invoice_item_hash)
    end
    next_value = (InvoiceItem.order(id: :desc).limit(1).pluck(:id)[0]) + 1
    # next_value = (InvoiceItem.last.id + 1)
    ActiveRecord::Base.connection.execute("alter sequence invoice_items_id_seq restart with #{next_value};")
    puts "Invoice_items created.", ""

    puts "Reading transaction data.", ""
    CSV.foreach("db/data/transactions.csv", headers: true, header_converters: :symbol, converters: :all) do |row|
      transaction_hash = row.to_h.except(:credit_card_expiration_date)
      if transaction_hash[:result] == "success"
        transaction_hash[:result] = 0
      elsif transaction_hash[:result] == "failed"
        transaction_hash[:result] = 1
      end
      Transaction.create(transaction_hash)
    end

    next_value = (Transaction.order(id: :desc).limit(1).pluck(:id)[0]) + 1
    ActiveRecord::Base.connection.execute("alter sequence transactions_id_seq restart with #{next_value};")
    puts "Transactions created.", ""

  end
