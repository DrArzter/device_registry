class User < ApplicationRecord
  has_many :api_keys, as: :bearer
  has_secure_password

  # When a user is destroyed, all of their assigned devices are also destroyed
  has_many :device_assignments, dependent: :destroy
  # Acessing the devices of a user through the device_assignments
  has_many :devices, through: :device_assignments
end
