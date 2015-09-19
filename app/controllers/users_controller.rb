class UsersController < ApplicationController

  def signup
    name = params[:name]
    username = params[:username]
    password = params[:password]

    user = User.new(name: name, username: username)
    user.password = password

    if user.save
      render json: {:success => true}
    else
      render json: {:success => false, :errors => user.errors.full_messages}
    end
  end

  def login
    username = params[:username]
    password = params[:password]

    user = User.find_by(username: username)
    success = false
    unless user.nil?
      success = true if user.validate_password(password)
    end
    render json: {:success => success}
  end
end
