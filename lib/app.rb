require_relative 'models/cat'

class App
  def self.inspect
    '<THE CATABASE>'
  end

  def initialize
    puts "Connecting to the CATABASE"
  end

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
    else
      puts "Error!"
      cat.errors.full_messages.each do |msg|
        puts msg
      end
    end

    nil
  end

  def list
    cats.each do |cat|
      show_cat(cat)
    end

    nil
  end

  def prowfile(cat_name)
    show_cat(find_cat(cat_name))

    nil
  end


  private

  def create_cat(attributes)
    Cat.create(attributes)
  end

  def cats
    Cat.all
  end

  def find_cat(name)
    Cat.where(name: name)
  end

  def show_cat(cat)
    puts cat
  end
end
