require 'test_helper'

class OffersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get accept" do
    get :accept
    assert_response :success
  end

  test "should get decline" do
    get :decline
    assert_response :success
  end

  test "should get invalidate" do
    get :invalidate
    assert_response :success
  end

end
