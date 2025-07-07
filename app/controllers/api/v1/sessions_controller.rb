# frozen_string_literal: true

# Controller for handling user sessions
class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      api_key = ApiKey.find_or_create_by!(bearer: user)

      render json: { token: api_key.token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    head :no_content
  end
end
