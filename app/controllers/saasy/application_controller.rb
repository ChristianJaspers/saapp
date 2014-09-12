class Saasy::ApplicationController < ApplicationController
  skip_before_action :autodetect_language
  skip_before_action :set_current_locale
end
