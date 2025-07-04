class CreateDeviceAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :device_assignments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true
      t.boolean :active, default: true, null: false # Track whether the device is assigned to the user
      t.datetime :returned_at

      t.timestamps
    end

    # Ensure that device can be assigned to a user only once at a time
    add_index :device_assignments, [:device_id, :active], where: "active = true", unique: true

  end
end
