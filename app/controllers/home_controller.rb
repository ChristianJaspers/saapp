class HomeController < ApplicationController
  expose(:wizard) { Wizard.new }
end
