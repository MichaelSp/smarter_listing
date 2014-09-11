require 'test_helper'

require 'smarter_listing'

class ListingsControllerTest < ActionController::TestCase
  setup do
    @listing = listings(:one)
    ListingsController.smarter_listing
  end

  test 'correct layout' do
    get :index
    assert_template 'default'
    assert_select '#layout', 'TAG'
  end

  test 'should have the methods from all helpers' do
    assert_includes @controller.methods, :create
    assert_includes @controller.methods, :show
    assert_includes @controller.methods, :update
    assert_includes @controller.methods, :destroy
    assert_includes @controller.methods, :new
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_equal [@listing], assigns(:listings)
    assert_select '#this_is_the_index', 'TAG'
    assert_select 'table#the_table'
    assert_select 'td', @listing.name
    assert_select 'td', @listing.content
    assert_select 'td.actions', 1
  end

  test "should get new" do
    xhr :get, :new, format: :js
    assert_response :success
    assert_equal 'text/javascript', @response.content_type
    assert_includes response.body, 'id=\\"the_form\\"'
  end

  test "should create listing" do
    assert_difference('Listing.count') do
      resource_params = {content: @listing.content, deleted_at: @listing.deleted_at, name: 'newName'}
      xhr :post, :create, listing: resource_params, format: :js
      assert_empty @listing.errors
    end
    assert_response :success
  end

  test 'should get edit' do
    xhr :get, :edit, id: @listing, format: :js
    assert_response :success
    assert_equal 'text/javascript', @response.content_type
    assert_includes response.body, 'id=\\"the_form\\"'
  end

  test 'should update listing' do
    resource_params = {content: @listing.content, deleted_at: @listing.deleted_at, name: 'newName'}
    xhr :patch, :update, id: @listing, listing: resource_params, format: :js
    assert_empty @listing.errors
    assert_response :success
    assert_includes response.body, '<td>newName<\\/td>'
    assert_includes response.body, @listing.content
  end

  test 'should destroy listing' do
    assert_difference('Listing.count', -1) do
      xhr :delete, :destroy, id: @listing, format: :js
    end
    assert_response :success
    assert_select 'tr', 0
  end
end
