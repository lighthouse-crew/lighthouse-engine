class LightGroupController < ApplicationController
  before_action :ensure_token_valid

  def index
  end

  def create
    name = params['name']
    description = params['description'] || ""
    individual = params['individual'] || false
    listed = params['listed'] || false

    light_group = LightGroup.create(
      owner: @current_user,
      name: name,
      description: description,
      individual: individual,
      listed: listed
      )

    if light_group.errors.empty?
      render json: {success: true}
    else
      render json: {success: false, :errors => light_group.errors.full_messages}
    end
  end

  def show
  end

  def update
  end

  def destroy
    name = params['name']
    light_group = LightGroup.find_by_id(params['id'])
    if light_group.nil?
      render json: {success: false, :errors => ["This light group does not exist"]}
    else
      if light_group.owner == @current_user
        success = light_group.destroy!
        render json: {success: true}
      else
        render json: {success: false, :errors => ["You are not the owner of this light group."]}
      end
    end
  end

  def join
  end

  def leave
  end 

end
