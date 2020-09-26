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
      expires_at = Time.now.to_i + 4 * 3600
      token = encode_token({ user_id: @user.id, first_name: @user.first_name, email: @user.email, expires_at: expires_at })
      decoded_token = JWT.decode(token, 's3cr3t', true, algorithm: 'HS256')
      render json: {user: @user, token: token, expires_at: decoded_token[0]['expires_at']}
    else
      render json: {error: 'Invalid email or password'}
    end
  end

  def auto_login
    render json: @user
  end

  def task_stats_header_data
    @user = User.find_by(email: params[:email])
    sql = "SELECT is_completed, tag_id from tasks JOIN users ON users.id = tasks.user_id
          JOIN tasks_tags ON tasks.id = tasks_tags.task_id WHERE user_id = #{@user.id} ORDER BY tag_id;"

    results = ActiveRecord::Base.connection.exec_query(sql).rows
    tag_success_data = {}
    results.each do |result|
      if tag_success_data.has_key?(result[1])
        tag_success_data[result[1]] = tag_success_data[result[1]].push(result[0])
      else
        tag_success_data[result[1]] = [result[0]]
      end
    end

    max_average_percentage = 0
    min_average_percentage = 100
    max_tag_id = 0
    min_tag_id = 0

    tag_success_data.each do |tag_id, data_array|
      percentage = data_array.sum * 100 / data_array.count
      if percentage > max_average_percentage
        max_average_percentage = percentage
        max_tag_id = tag_id
      end
      if percentage < min_average_percentage
        min_average_percentage = percentage
        min_tag_id = tag_id
      end
    end

    @data = {
      favorite_tag: @user.tags.group('name').order('count_all desc').limit(1).count,
      least_favorite_tag: @user.tags.group('name').order('count_all').limit(1).count,
      most_successfull_tag: max_tag_id.positive? ? { name: Tag.find(max_tag_id).name, percentage: max_average_percentage } : {},
      toughest_tag: min_tag_id.positive? ? { name: Tag.find(min_tag_id).name, percentage: min_average_percentage } : {}
    }
    render json: @data
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :full_name, :email, :password, :password_confirmation, :dob, :user)
  end
end
