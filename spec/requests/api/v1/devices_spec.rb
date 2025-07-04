# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Devices', type: :request do
    let!(:user) { create(:user) }
    let!(:api_key) { create(:api_key, bearer: user) }
    let!(:device) { create(:device) }
    let(:auth_headers) {{ 'Authorization' => "Bearer #{api_key.token}" }}

    describe "POST /api/v1/devices/assign" do
        let (:valid_params) { { device: { serial_number: device.serial_number } } }

        context "when valid params and user is authenticated" do
           it "assigns the device to the user and returns status 200 (ok)" do
               post "/api/v1/devices/assign", params: valid_params, headers: auth_headers, as: :json
               expect(response).to have_http_status(:ok)
               expect(device.reload.current_owner).to eq(user)
           end
        end

        context "when service fails" do
            it "returns status 422 (unprocessable entity) and error message" do
                create(:device_assignment, user: user, device: device)
                post "/api/v1/devices/assign", params: valid_params, headers: auth_headers, as: :json
                expect(response).to have_http_status(422)
                json_response = JSON.parse(response.body)
                expect(json_response['error']).to eq('device_already_assigned')
            end
        end

        context "when user is not authenticated" do
            it "returns status 401 (unauthorized)" do
                post "/api/v1/devices/assign", params: valid_params, as: :json
                expect(response).to have_http_status(:unauthorized)
            end
        end
    end

    describe "POST /api/v1/devices/unassign" do
        let (:valid_params) { { device: { serial_number: device.serial_number } } }

        context "when valid params and user is authenticated" do
            before { create(:device_assignment, user: user, device: device) }

            it "unassigns the device from the user and returns status 200 (ok)" do
                post "/api/v1/devices/unassign", params: valid_params, headers: auth_headers, as: :json
                expect(response).to have_http_status(:ok)
                expect(device.reload.current_owner).to be_nil
            end
        end

        context "when service fails" do
            it "returns status 422 (unprocessable entity) and error message" do
                post "/api/v1/devices/unassign", params: valid_params, headers: auth_headers, as: :json
                expect(response).to have_http_status(422)
                json_response = JSON.parse(response.body)
                expect(json_response['error']).to eq('device_not_assigned')
            end
        end

        context "when user is not authenticated" do
            it "returns status 401 (unauthorized)" do
                post "/api/v1/devices/unassign", params: valid_params, as: :json
                expect(response).to have_http_status(:unauthorized)
            end
        end
    end
end