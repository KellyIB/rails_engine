#rake task should:
# Clear your Development database to prevent data duplication
# Seed your Development database with the CSV data
# Be invokable through Rake, i.e. you should be able to run bundle exec rake <your_rake_task_name> from the command line
# Convert all prices before storing. Prices are in cents, therefore you will need to transform them to dollars. (12345 becomes 123.45)
# Reset the primary key sequence for each table you import so that new records will receive the next valid primary key.
# desc "clear and seed development database, convert cents to dollars, and reset primary key sequence"
#
# task :csv_seed do
#   rails db:drop
#
# end
