# Moar ActiveRecord!

- Live coding example!
- Validating crappy input!
- Callbacks (that look completely different from what you think of as callbacks)!
- Probably about cats!

## Check out app structure

It's like the Employees/Stores setup, mostly.

## Plan the app: the Catabase

It could be a command-line app. But maybe let's not really
deal with ARGV or `while(true)` or any of that, and interact
with it from pry instead.

But we can still build an `App` class to represent what we
want our cat users to be able to do.

Which is...

- Cats can sign themselves up to create their prowfile
  - or login if they already have one
- Cats can look at each other's prowfiles
- Cats can send each other meowssages
- Cats can delete their prowfiles
  - All their meowssages should get deleted
- (sorry not sorry)

(We are pretending this is multi-user even though it's not.)

## Idea for schema:

Cat

  - name
  - age:integer
  - legs:integer
  - fur_length:string
  - occupation:string
  - favourite_restaurant:string

Message

  - belongs to a Cat
  - content

### Actual definition:

```ruby
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
```

## REPL app

Structure of the example app is based around an `App` class
and a Pry session:

```ruby
app = App.new
app.pry
```

The app has a bunch of "UI methods", which are things the user can type in the REPL.
It asks for input with gets rather than taking arguments.

There are also some private methods to supplement the UI methods.

## Registration: need validation

We saw that we could create a new user with all empty attributes. Not good!

We added validations as per the docs:

http://guides.rubyonrails.org/active_record_validations.html

We also saw what happens when validation fails.

If we tried to use `#save!` or `#create!`, it would raise an error.

If we used `#save` or `#create`, then the object would respond `cat.valid? == false` and `cat.errors` would not be empty.

We can iterate over `cat.errors` (containing records of each error, including which field and which validation failed), or we can iterate over `cat.errors.full_messages` which maps each error to a full, natural language phrase describing the error, good for showing the user.

## Callbacks

ActiveRecord callbacks are about running code before and/or after certain events. We can register callbacks around validation, save, initial creation, deletion, etc...

- http://guides.rubyonrails.org/active_record_callbacks.html
- http://guides.rubyonrails.org/active_record_callbacks.html#available-callbacks

We added a callback to create a new Message when a new Cat is registered.

We talked about how we could delete all messages for a Cat when the Cat deletes their account, using an `after_delete` callback... but there's a better way.

## `dependent: :destroy`

On the association, on the "has many" side, we can add an option:

```ruby
class Cat < ActiveRecord::Base

  has_many :messages, dependent: :destroy

  # ...
end
```

This means, when a cat is deleted, delete (destroy) any associated messages.


## Testing it out

```terminal
> bundle exec ruby scripts/run.rb                                                                  (prototype|✚2…1)
Establishing connection to database ...CONNECTED
Connecting to the CATABASE

[1] pry(#<App>)> list
=> nil

[2] pry(#<App>)> register
Name plz: Donald
Age (in cat years): 44
How many legs do you still have? 4
What's your fur like homey? fake
What do you do? make things great again
Posting about new cat
Thanks for registering, Donald!
=> nil

[3] pry(#<App>)> compose
What is your message?
I don't want to call anyone a loser but...
Posted
=> nil

[4] pry(#<App>)> compose
What is your message?
I'm gonna build a wall... a catabase wall
Posted
=> nil

[5] pry(#<App>)> list
- Donald the Cat
=> nil

[6] pry(#<App>)> messages
Donald: A new cat signed up! Welcome Donald
Donald: I don't want to call anyone a loser but...
Donald: I'm gonna build a wall... a catabase wall
=> nil

[7] pry(#<App>)> delete
Are you SURE you wanna delete your account? y
Deleted.

[8] pry(#<App>)> messages
=> nil

```

