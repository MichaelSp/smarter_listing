require 'test_helper'

class SmarterListingLoaderTest < ActiveSupport::TestCase

  test 'smarter listing is loaded' do
    assert_respond_to ActionController::Base, :smarter_listing
  end

  test 'controller extensions are loaded' do
    assert_not_includes ListingsController.included_modules, SmartListing::Helper::ControllerExtensions
    assert_not_includes ListingsController.included_modules, SmarterListing::ControllerExtension
    ListingsController.smarter_listing
    assert_includes ListingsController.included_modules, SmartListing::Helper::ControllerExtensions
    assert_includes ListingsController.included_modules, SmarterListing::ControllerExtension
  end

  test 'helper methods included' do
    ListingsController.smarter_listing
    methods = SmartListing::Helper.instance_methods + SmarterListing::Helper.instance_methods
    methods.each do |method|
      assert_includes ListingsController.helpers.methods, method
    end
  end

  test 'attribute filter_parameter' do
    assert_not_includes ListingsController.instance_variables, :@filter_parameter
  end

  test 'the default filter_parameter' do
    ListingsController.smarter_listing
    assert_includes ListingsController.instance_variables, :@filter_parameter
    assert_equal :filter, ListingsController.instance_variable_get(:@filter_parameter)
  end

  test 'setting a filter_parameter' do
    ListingsController.smarter_listing :qry
    assert_equal :qry, ListingsController.instance_variable_get(:@filter_parameter)
  end
end