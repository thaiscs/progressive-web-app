class ApplicationController < ActionController::Base
  # allow_browser versions: :modern #todo: activate in rails 8
  def identify_user
    user_id = cookies.signed[:user_id]

    if user_id && User.exists?(user_id)
      @current_user = User.find(user_id)
    else
      @current_user = User.create
      cookies.signed.permanent[:user_id] = {
        value: @current_user.id,
        secure: Rails.env.production?,
        httponly: true,
        same_site: :strict
      }
      #todo: banner notification for cookies https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#cookie-related_regulations
    end
    # read cookies
    # byebug 
  end
end
