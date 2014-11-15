require 'smarter_listing/engine'
require 'kaminari'

module SmarterListing
  autoload :Helper, 'smarter_listing/helper'
  autoload :ControllerExtension, 'smarter_listing/controller_extension'

  module Loader
    def self.extended base
      def smarter_listing(filter_parameter = :filter)
        helper SmartListing::Helper unless _helper_methods.include?(:smart_listing_item)
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