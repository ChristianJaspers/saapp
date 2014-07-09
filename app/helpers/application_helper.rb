module ApplicationHelper
  def logged_in?
    current_user.present?
  end

  def guest?
    not logged_in?
  end
end
