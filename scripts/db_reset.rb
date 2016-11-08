require_relative '../boot'

puts 'Resetting database...'

ActiveRecord::Schema.define do
  # drop_table :employees if ActiveRecord::Base.connection.table_exists?(:employees)
  # create_table :employees do |table|
  #   table.references :store
  #   table.column :first_name, :string
  #   table.column :last_name, :string
  #   table.column :hourly_rate, :integer
  #   table.timestamps null: false
  # end
end

puts 'Setup DONE'
