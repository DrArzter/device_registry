class Device < ApplicationRecord

    # Device can have many assignments (history)
    has_many :device_assignments, dependent: :destroy
    has_many :users, through: :device_assignments

    # Get the current owner of the device
    def current_owner
      device_assignments.find_by(active: true)&.user
    end

    # Check if the device was previously assigned to the user
    def previously_assigned_to?(user)
      device_assignments.exists?(user: user)
    end

end
