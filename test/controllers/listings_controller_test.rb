require "test_helper"

require 'smarter_listing'

describe ListingsController do
  before do
    subject.class.smarter_listing
  end
  subject { ListingsController.new }
  let(:listing) { listings(:one) }

  test 'correct layout' do
    get listings_url
    assert_template 'default'
    assert_select '#layout', 'TAG'
  end

  test 'should have the methods from all helpers' do
    assert_includes ListingsController.included_modules, SmarterListing::ControllerExtension
  end

  test "should get index" do
    get listings_url
    assert_response :success
    assert_equal [listing], assigns(:listings)
    assert_select '#this_is_the_index', 'TAG'
    assert_select 'table#the_table'
    assert_select 'td', listing.name
    assert_select 'td', listing.content
    assert_select 'td.actions', 1
  end

  test "should create listing" do
    assert_difference('Listing.count') do
      resource_params = {content: listing.content, deleted_at: listing.deleted_at, name: 'newName'}
      post listings_path(format: :js), params: {listing: resource_params}, xhr: true
      assert_empty listing.errors
    end
    assert_response :success
  end

  test 'should update listing' do
    resource_params = {content: listing.content, deleted_at: listing.deleted_at, name: 'newName'}
    patch listing_path(listing, format: :js), params: {listing: resource_params}, xhr: true
    assert_empty listing.errors
    assert_response :success
    assert_select 'td', "newName\\n"
    assert_includes response.body, listing.content
  end

  test 'should destroy listing' do
    assert_difference('Listing.count', -1) do
      delete listing_path(listing, format: :js), xhr: true
    end
    assert_response :success
    assert_select 'tr', 0
  end

  describe 'edit' do
    test 'get js' do
      get edit_listing_path(listing, format: :js), xhr: true
      assert_response :success
      assert_equal 'text/javascript', response.media_type
      assert_includes response.body, 'the_form'
    end


    test 'get html' do
      get edit_listing_path(listing)
      assert_response :success
      assert_equal 'text/html', response.media_type
      assert_select "tr.editable[data-id=\"#{listing.id}\"]"
    end
  end

  describe :new do
    test 'get js' do
      get new_listing_path(format: :js), xhr: true
      assert_response :success
      assert_equal 'text/javascript', response.media_type
      assert_includes response.body, 'smart_listing.new_item'
      assert_includes response.body, 'the_form'
    end

    test 'get html' do
      get new_listing_path
      assert_response :success
      assert_equal 'text/html', response.media_type
      assert_includes response.body, 'the_form'
      assert_includes response.body, '$(\'#listings\').smart_listing();'
      assert_includes response.body, "smart_listing.new_item("
      assert_includes response.body, "event.initEvent('form:load', true, true);"
    end
  end
end
