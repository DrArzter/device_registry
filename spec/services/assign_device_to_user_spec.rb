# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignDeviceToUser do
  let(:result_struct) { Struct.new(:success?, :data, :error) }

  let!(:user) { create(:user) }
  let!(:device) { create(:device) }

  subject(:call_service) do
    described_class.new(
      requesting_user: user,
      serial_number: device.serial_number
    ).call
  end

  context 'when device is available and unassigned' do
    it 'assigns the device to the user' do
      expect { call_service }.to change(DeviceAssignment, :count).by(1)
    end

    it 'returns a successful result object' do
      result = call_service
      expect(result).to be_success
      expect(result.error).to be_nil
      expect(result.data).to be_a(DeviceAssignment)
    end

    it 'associates the assignment with the correct user and device' do
      call_service
      assignment = DeviceAssignment.last
      expect(assignment.user).to eq(user)
      expect(assignment.device).to eq(device)
      expect(assignment.active).to be(true)
    end
  end

  context 'when device is already assigned to another user' do
    let!(:another_user) { create(:user) }
    before { create(:device_assignment, device: device, user: another_user) }

    it 'does not create a new assignment' do
      expect { call_service }.not_to change(DeviceAssignment, :count)
    end

    it 'returns a failure result with an error code' do
      result = call_service
      expect(result).not_to be_success
      expect(result.error).to eq(:device_already_assigned)
    end
  end

  context 'when user tries to re-assign a device they previously returned' do
    before { create(:device_assignment, :returned, device: device, user: user) }

    it 'does not create a new assignment' do
      expect { call_service }.not_to change(DeviceAssignment, :count)
    end

    it 'returns a failure result with an error code' do
      result = call_service
      expect(result).not_to be_success
      expect(result.error).to eq(:reassign_forbidden)
    end
  end

  context 'when device with given serial number does not exist' do
    subject(:call_service) do
      described_class.new(
        requesting_user: user,
        serial_number: 'NON-EXISTENT-SN'
      ).call
    end

    it 'returns a failure result' do
      result = call_service
      expect(result).not_to be_success
      expect(result.error).to eq(:device_not_found)
    end
  end
end