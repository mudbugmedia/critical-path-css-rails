require 'rubygems'
require 'bundler'
require 'combustion'

Combustion.initialize! :action_controller, :action_view
run Combustion::Application
