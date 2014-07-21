class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  expose(:static_pages) { Array.wrap(Comfy::Cms::Page.find_by(slug: 'index').try { |root| root.children.published }) }
end
