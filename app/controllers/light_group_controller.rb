class LightGroupController < ApplicationController
  before_action :ensure_token_valid
  around_filter :load_light_group, except: [:create, :index]

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
      light_group.add_user(@current_user)
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
    if @light_group.owner == @current_user
      success = @light_group.destroy!
      render json: {success: true}
    else
      render json: {success: false, :errors => ["You are not the owner of this light group."]}
    end
  end

  def join
    @light_group.add_user(@current_user)
    render json: {success: true}
  end

  def leave
      @light_group.remove_user(@current_user)
      render json: {success: true}
  end 

  private

    def load_light_group
      begin
        @light_group = LightGroup.find(params[:id])
        yield
      rescue ActiveRecord::RecordNotFound => e
        render json: {success: false, error: 'Cannot find the light group.'}
      end
    end

end
