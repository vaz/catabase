# gem requires
require 'pry'
require 'active_record'

# require the app
# require_relative 'lib/...'


# Output messages from Active Record to standard out
ActiveRecord::Base.logger = Logger.new(STDOUT)

print 'Establishing connection to database ...'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: ENV['DB_NAME'] || 'catabase',
  username: ENV['DB_USER'] || ENV['USER'],
  password: ENV['DB_PASS'] || nil,
  host: ENV['DB_HOST'] || 'localhost',
  port: ENV['DB_PORT'] || 5432,
  pool: 5,
  encoding: 'unicode',
  min_messages: 'error'
)

puts 'CONNECTED'

