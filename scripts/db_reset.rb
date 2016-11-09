require_relative '../boot'

puts 'Resetting database...'

ActiveRecord::Schema.define do
  drop_table :cats if ActiveRecord::Base.connection.table_exists?(:cats)
  create_table :cats do |t|
    t.column :name, :string
    t.column :age, :integer
    t.column :number_of_legs, :integer
    t.column :fur, :string
    t.column :occupation, :string
    t.timestamps null: false
  end
  drop_table :messages if ActiveRecord::Base.connection.table_exists?(:messages)
  create_table :messages do |t|
    t.references :cat
    t.column :content, :string
    t.timestamps null: false
  end
end

puts 'Setup DONE'
