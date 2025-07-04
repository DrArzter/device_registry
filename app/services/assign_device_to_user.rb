# frozen_string_literal: true

class AssignDeviceToUser
  Result = Struct.new(:success?, :data, :error, keyword_init: true)

  def initialize(requesting_user:, serial_number:)
    @user = requesting_user
    @serial_number = serial_number
    @device = Device.find_by(serial_number: @serial_number)
  end

  def call
    return failure(:device_not_found) unless @device

    return failure(:device_already_assigned) if @device.current_owner.present?

    return failure(:reassign_forbidden) if @device.previously_assigned_to?(@user)

    assignment = DeviceAssignment.new(user: @user, device: @device)

    if assignment.save
      success(assignment)
    else
      failure(:validation_error, assignment.errors.full_messages)
    end
  end

  private

  def success(data = nil)
    Result.new(success?: true, data: data)
  end

  def failure(error_code, data = nil)
    Result.new(success?: false, error: error_code, data: data)
  end
end