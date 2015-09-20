require 'notification_helper'

class LightGroupsController < ApplicationController
  before_action :ensure_token_valid
  around_filter :load_light_group, except: [:create, :index, :find_and_join]

  include NotificationHelper

  def index
    light_groups = nil
    if params[:id]
      # The light groups the current user is in
      light_groups = @current_user.light_groups
    else
      # All listed light groups
      light_groups = LightGroup.where(listed: true)
    end
    render json: {
      success: true,
      light_groups: light_groups.map do |g|
        {
          id: g.id,
          owner_id: g.owner_id,
          name: g.name,
          description: g.description,
          individual: g.individual,
          listed: g.listed,
          my_state: g.lights.find_by(user: @current_user).state
        }
      end
    }
  end

  def create
    name = params[:name]
    description = params[:description]
    individual = params[:individual]
    listed = params[:listed]

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
    # Only show if user is in the group or group is listed
    if @light_group.has_user(@current_user) || @light_group.listed
      render json: {
        success: true,
        id: @light_group.id,
        owner_id: @light_group.owner_id,
        name: @light_group.name,
        description: @light_group.description,
        individual: @light_group.individual,
        listed: @light_group.listed,
        members: @light_group.lights.map do |l|
          {
            user_name: User.find(l.user_id).name,
            state: l.state,
            label: l.label,
            expires_at: l.expires_at,
            updated_at: l.updated_at
          }
        end
      }
    else
      render json: {success: false, error: ["Light group is not publicly listed and you are not a members"]}
    end
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

  def find_and_join
    @light_group = LightGroup.find_by_name(params[:name])
    if @light_group.nil?
      render json: {success: false}
    else
      @light_group.add_user(@current_user)
      render json: {success: true}
  end
  end

  def leave
      @light_group.remove_user(@current_user)
      render json: {success: true}
  end 

  def update_light
    new_state = params[:state].to_i
    new_label = params[:label]
    light = @light_group.lights.find_by(user: @current_user)
    if light.nil?
      render json: {success: false, error: ["User is not in this light group"]}
    else
      light.state = new_state
      success = false
      case new_state
      when LightGroup::INACTIVE
        light.label = ""
        success = light.save
      when LightGroup::SEARCHING
        light.label = new_label
        success = light.save
        puts light.reload
      when LightGroup::ACTIVE
        success = light.save
        @light_group.lights.where(label: light.label).each do |l|
          l.state = LightGroup::ACTIVE
          success = success and l.save
        end
      end
      if success
        render json: {
          success: true,
          light_group_id: light.light_group_id,
          user_name: light.user.name,
          state: light.state,
          label: light.label,
          expires_at: light.expires_at
        }
        sms_recipients = @light_group.users.reject {|u| u.id==@current_user.id}.map(&:device_token)
        case new_state
        when LightGroup::SEARCHING
          sms_content = "LIGHTHOUSE: #{light.user.name} is now searching in #{light.light_group.name}: #{light.label}"
          send_sms_notifications(sms_recipients, sms_content)
        when LightGroup::ACTIVE
          sms_content = "LIGHTHOUSE: Activity started on #{light.light_group.name}: #{light.label}"
          send_sms_notifications(sms_recipients, sms_content)
        end
      else
        render json: {success: false, error: light.errors.full_messages.join("\n")}
      end
    end
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
