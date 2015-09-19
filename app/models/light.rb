class Light < ActiveRecord::Base
    belongs_to :light_groups
    belongs_to :users
end
