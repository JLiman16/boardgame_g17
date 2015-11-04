class BggAccount < ActiveRecord::Base
  belongs_to :user
  has_one :collection, dependent: :destroy
  validates :user_id, presence: true
end
