module ApplicationHelper
  def logged_in?
    false #FIXME Temporary implementation
  end

  def guest?
    not logged_in?
  end
end
