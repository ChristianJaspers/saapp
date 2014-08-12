# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require underscore-min
#= require angular.min
#= require ng-rails-csrf
#= require angular-ui-bootstrap-tpls
#= require angular-resource.min
#= require angular-rails-templates
#= require_tree ../templates
#= require spin
#= require ladda

#= require_tree .

window.autofocus_visible_inputs = -> $("input[autofocus]:visible").trigger('focus')
window.bind_submit_buttons_with_loader = -> Ladda.bind('.ladda-button')
