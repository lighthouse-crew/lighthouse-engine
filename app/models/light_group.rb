class LightGroup < ActiveRecord::Base
  has_many :lights, dependent: :destroy
  has_many :users, through: :lights
  belongs_to :owner, class_name: 'User'

  before_save :assign_defaults
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  INACTIVE = 0
  ACTIVE = 1
  IN_PROGRESS = 2
  STATE_STRING = ['inactive', 'active', 'in progress']

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

  def has_user(user)
    return !self.lights.find_by(user: user).nil?
  end

  private

    def assign_defaults
      self.description = "" if self.description.nil?
      self.individual = false if self.individual.nil?
      self.listed = true if self.listed.nil?
    end

end
