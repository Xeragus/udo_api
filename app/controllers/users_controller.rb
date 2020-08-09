class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login]

  def register
    user_data = user_params
    user_data[:full_name] = user_params[:first_name] + user_params[:last_name]

    @user = User.create(user_data)
    if @user.valid?
      expires_at = Time.now.to_i + 4 * 3600
      token = encode_token({ user_id: @user.id, first_name: @user.first_name, email: @user.email, expires_at: expires_at })

      decoded_token = JWT.decode(token, 's3cr3t', true, algorithm: 'HS256')
      render json: {user: @user, token: token, expires_at: decoded_token[0]['expires_at']}
    else
      render json: @user.errors.messages
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      token = encode_token({user_id: @user.id})
      decoded_token = JWT.decode(token, 's3cr3t', true, algorithm: 'HS256')
      render json: {user: @user, token: token, expires_at: decoded_token[0]['expires_at']}
    else
      render json: {error: 'Invalid email or password'}
    end
  end

  def auto_login
    render json: @user
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :full_name, :email, :password, :password_confirmation, :dob, :user)
  end
end
