class Token < ActiveRecord::Base
    belongs_to :user

    def deactivate!
        self.update!(active: false)
    end
end
