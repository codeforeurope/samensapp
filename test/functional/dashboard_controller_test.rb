require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  test "should get incoming" do
    get :incoming
    assert_response :success
  end

  test "should get sent" do
    get :sent
    assert_response :success
  end

  test "should get confirmed" do
    get :confirmed
    assert_response :success
  end

  test "should get to_invoice" do
    get :to_invoice
    assert_response :success
  end

end
