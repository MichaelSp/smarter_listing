require 'smart_listing'
require 'kaminari'

module SmarterListing
  module Loader
    def initialize

    end

    def self.extended base
      def smarter_listing(filter_parameter = :filter)
        helper SmartListing::Helper
        include SmartListing::Helper::ControllerExtensions

        helper SmarterListing::Helper
        include SmarterListing::ControllerExtension

        instance_variable_set :@filter_parameter, filter_parameter
        prepend Loader
      end
    end
  end
end

ActionController::Base.extend SmarterListing::Loader