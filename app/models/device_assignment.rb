class DeviceAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :device

  # Validate that returned_at is present when active is false
  validates :returned_at, presence: true, if: -> { !active? }
end
