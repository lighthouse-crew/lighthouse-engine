class UsersController < ApplicationController

  def signup
    name = params[:name]
    username = params[:username]
    password = params[:password]

    user = User.new(name: name, username: username)
    user.password = password

    if user.save
      render json: {success: true}
    else
      render json: {success: false, errors: user.errors.full_messages}
    end
  end

  def signin
    username = params[:username]
    password = params[:password]

    user = User.find_by(username: username)
    success = false
    unless user.nil?
      if user.validate_password(password)
        success = true
        user.create_token
      end
    end
    if success
      render json: {success: true, token: user.active_token.value, uid: user.id}
    else
      render json: {success: false}
    end
  end

  def signout
    username = params[:username]
    user = User.find_by(username: username)
    unless user.nil?
      user.active_token.deactivate!
    end
    render json: {success: !user.nil?}
  end
end
