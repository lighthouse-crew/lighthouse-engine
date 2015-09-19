class LightGroup < ActiveRecord::Base
  has_many :lights, dependent: :destroy
  has_many :users, through: :lights
  belongs_to :owner, class_name: 'User'

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  INACTIVE = 0

  def add_user(user)
    if self.lights.find_by(user: user).nil?
      self.lights.create!(
        user: user,
        state: INACTIVE,
      )
    end
  end

  def remove_user(user)
    self.lights.where(user: user).each do |l|
      l.destroy!
     end 
  end

end
