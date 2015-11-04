class BggAccount < ActiveRecord::Base
  belongs_to :user
  has_many :games, dependent: :destroy
  validates :user_id, presence: true
end
