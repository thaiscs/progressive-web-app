class ApplicationController < ActionController::Base
  # allow_browser versions: :modern #todo: activate in rails 8
  def identify_user
    user_id = cookies.signed[:user_id]
    
    if user_id && User.exists?(user_id)
      @current_user = User.find(user_id)
    else
      @current_user = User.create
      cookies.signed[:user_id] = {
        value: @current_user.id,
        expires: 1.year.from_now,
        secure: Rails.env.production?
      }
    end
  end
end
