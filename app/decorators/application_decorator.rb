class ApplicationDecorator < Draper::Decorator
  delegate_all

  delegate :link_to, :current_user, to: :h
end
