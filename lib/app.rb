require_relative 'models/cat'
require_relative 'models/message'

class App
  attr_reader :current_cat

  def initialize
    puts "Connecting to the CATABASE"
    @current_cat = nil
  end

  # UI Methods:

  def register
    print 'Name plz: '
    name = gets.chomp
    print 'Age (in cat years): '
    age = gets.chomp
    print 'How many legs do you still have? '
    legs = gets.chomp
    print "What's your fur like homey? "
    fur = gets.chomp
    print 'What do you do? '
    occupation = gets.chomp

    cat = create_cat(name: name, age: age, number_of_legs: legs, fur: fur, occupation: occupation)

    if cat.valid?
      puts "Thanks for registering, #{cat.name}!"
      @current_cat = cat
    else
      puts "Error!"
      cat.errors.full_messages.each do |msg|
        puts msg
      end
    end

    # Stop pry from printing out whatever the last value was:
    nil
  end

  def login
    print "Log in as: "
    name = gets.chomp
    cat = find_cat(name)
    if cat.nil?
      puts "No account found for #{name}"
    else
      puts "Logged in as #{cat.name}!"
      @current_cat = cat
    end
    nil
  end

  def whoami
    puts current_cat
    nil
  end

  def list
    cats.each do |cat|
      puts "- #{cat}"
    end

    nil
  end

  def prowfile
    print "Which prowfile? "
    name = gets.chomp
    cat = find_cat(name)
    puts "Prowfile: #{cat.name}"
    puts "- age: #{cat.age}"
    puts "- number of legs: #{cat.number_of_legs}"
    puts "- fur is like: #{cat.fur}"
    puts "- occupation: #{cat.occupation}"

    show_cat(find_cat(name))

    nil
  end

  def compose
    puts "What is your message?"
    content = gets.chomp

    message = post_message(current_cat, content)

    if message.valid?
      puts "Posted"
    else
      puts "Bad message!"
      message.errors.full_messages.each do |msg|
        puts msg
      end
    end

    nil
  end

  def messages
    all_messages.each do |msg|
      puts msg
    end
    nil
  end

  def delete
    if current_cat.nil?
      puts "log in first"
    else
      print "Are you SURE you wanna delete your account? "
      if gets.chomp.downcase == 'y'
        current_cat.destroy
      end
    end
  end


  private

  def create_cat(attributes)
    Cat.create(attributes)
  end

  def cats
    Cat.all
  end

  def find_cat(name)
    Cat.find_by_name(name)
  end

  def show_cat(cat)
    puts "- #{cat}"
  end

  def post_message(cat, content)
    Message.create(cat_id: cat.id, content: content)
  end

  def all_messages
    Message.all.map { |message| "#{message.cat.name}: #{message.content}" }
  end
end
