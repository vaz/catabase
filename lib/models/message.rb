class Message < ActiveRecord::Base
  belongs_to :cat

  validates :cat_id,  presence: true
  validates :content, presence: true
end
