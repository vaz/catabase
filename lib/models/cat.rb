class Cat < ActiveRecord::Base

  validates :name, length: { in: 2..24 }
  validates :name, uniqueness: true
  validates :age, presence: true
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 13 }
  validates :occupation, presence: true

  def to_s
    "#{name} the Cat"
  end
end

