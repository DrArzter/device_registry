# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  Result = Struct.new(:success?, :data, :error, keyword_init: true)

  let!(:owner) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:device) { create(:device) }

  subject(:call_service) do
    described_class.new(
      requesting_user: owner,
      serial_number: device.serial_number
    ).call
  end

  context 'when the current owner returns their device' do
    let!(:assignment) { create(:device_assignment, user: owner, device: device) }

    it 'marks the assignment as inactive' do
      call_service
      expect(assignment.reload.active).to be(false)
    end

    it 'sets the returned_at timestamp' do
      call_service
      expect(assignment.reload.returned_at).to be_within(1.minute).of(Time.current)
    end

    it 'returns a successful result' do
      result = call_service
      expect(result).to be_success
      expect(result.data).to eq(assignment)
    end
  end

  context 'when another user tries to return the device' do
    let!(:assignment) { create(:device_assignment, user: owner, device: device) }

    subject(:call_service) do
      described_class.new(
        requesting_user: another_user,
        serial_number: device.serial_number
      ).call
    end

    it 'does not change the assignment' do
      expect { call_service }.not_to(change { assignment.reload.active })
    end

    it 'returns a failure result with an error' do
      result = call_service
      expect(result).not_to be_success
      expect(result.error).to eq(:not_your_device)
    end
  end

  context 'when trying to return an already returned device' do
    let!(:assignment) { create(:device_assignment, :returned, user: owner, device: device) }

    it 'returns a failure result with an error' do
      result = call_service
      expect(result).not_to be_success
      expect(result.error).to eq(:device_not_assigned)
    end
  end

  context 'when device with given serial number does not exist' do
    subject(:call_service) do
      described_class.new(
        requesting_user: owner,
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