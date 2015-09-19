class Light < ActiveRecord::Base
    belongs_to :light_group
    belongs_to :user

    validates :state, presence: true, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 2}
    validates :label, length: {maximum: 20}
end
