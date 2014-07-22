class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  expose(:static_pages) { Array.wrap(Comfy::Cms::Page.find_by(slug: 'index').try { |root| root.children.published }) }

  private

  def after_sign_in_path_for(resource)
    root_url
  end
end
