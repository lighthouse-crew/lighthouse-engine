class LightGroup < ActiveRecord::Base
  has_many :lights
  has_many :users, through: :lights
  belongs_to :owner, class_name: 'User'

  validates :name, presence: true, uniqueness: { case_sensitive: false }

end
