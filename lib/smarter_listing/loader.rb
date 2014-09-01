require 'smart_listing'
require 'kaminari'

module SmarterListing
  module Loader
    def self.extended base
      def smarter_listing(filter_parameter = :filter)
        helper SmartListing::Helper
        include SmartListing::Helper::ControllerExtensions
        include SmarterListing::Helper
        include SmarterListing::ControllerExtension

        self.instance_variable_set :@filter_parameter, filter_parameter
      end
    end
  end
end

ActionController::Base.extend SmarterListing::Loader