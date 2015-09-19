class LightGroup < ActiveRecord::Base
    has_many :lights
    has_many :users, through: :lights
    has_one :owner, class_name: 'User'
end
