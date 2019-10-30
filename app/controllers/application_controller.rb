class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def logged_in_user?
  end

  def correct_user?
  end

  def admin_user?
  end

end
