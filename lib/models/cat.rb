class Cat < ActiveRecord::Base

  has_many :messages, dependent: :destroy

  validates :name, length: { in: 2..24 }
  validates :name, uniqueness: true
  validates :age, presence: true
  validates :age, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 13,
    less_than: 100
  }
  validates :occupation, presence: true

  after_create :post_about_new_cat

  def to_s
    "#{name} the Cat"
  end

  private

  def post_about_new_cat
    puts "Posting about new cat"
    Message.create(cat_id: id, content: "A new cat signed up! Welcome #{name}")
  end
end

