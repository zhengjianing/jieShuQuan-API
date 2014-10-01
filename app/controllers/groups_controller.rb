class GroupsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /groups/999
  def index
    if params[:password] == "999"
      result = Group.all.map do |group|
        {
            name: group.name,
            users_count: group.users.size,
            created_at: group.created_at.time.strftime('%Y-%m-%d')
        }
      end
      render json: result
    else
      render json: {error: 'wrong password'}
    end
  end

end