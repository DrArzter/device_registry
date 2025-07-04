# frozen_string_literal: true

class ReturnDeviceFromUser
  Result = Struct.new(:success?, :data, :error, keyword_init: true)

  def initialize(requesting_user:, serial_number:)
    @user = requesting_user
    @serial_number = serial_number
    @device = Device.find_by(serial_number: @serial_number)
  end

  def call

    return failure(:device_not_found) unless @device

    assignment = @device.device_assignments.find_by(active: true)
    return failure(:device_not_assigned) unless assignment

    return failure(:not_your_device) unless assignment.user == @user

    if assignment.update(active: false, returned_at: Time.current)
      success(assignment)
    else
      failure(:update_failed, assignment.errors.full_messages)
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