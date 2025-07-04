class Api::V1::DevicesController < ApplicationController

    # POST /api/v1/devices/assign
    def assign
       result = AssignDeviceToUser.new(
           requesting_user: @current_user,
           serial_number: device_params[:serial_number],
       ).call
        if result.success?
            head :ok
        else
            render json: { error: result.error }, status: :unprocessable_entity
        end
    end

    # POST /api/v1/devices/unassign
    def unassign
        result = ReturnDeviceFromUser.new(
            requesting_user: @current_user,
            serial_number: device_params[:serial_number],
        ).call

        if result.success?
            head :ok
        else
            render json: { error: result.error }, status: :unprocessable_entity
        end
    end

    private

    def device_params
        params.require(:device).permit(:serial_number)
    end
end