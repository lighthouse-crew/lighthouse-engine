class LightGroup < ActiveRecord::Base
  has_many :lights, dependent: :destroy
  has_many :users, through: :lights
  belongs_to :owner, class_name: 'User'

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def add_user(user)
    self.lights.create!(
      user: user,
      state: 0,
      )
  end

end
