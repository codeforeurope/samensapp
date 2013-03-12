require 'test_helper'

class RoomConfigurationsControllerTest < ActionController::TestCase
  setup do
    @room_configuration = room_configurations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:room_configurations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create room_configuration" do
    assert_difference('RoomConfiguration.count') do
      post :create, room_configuration: { capacity: @room_configuration.capacity, name: @room_configuration.name, room_id: @room_configuration.room_id }
    end

    assert_redirected_to room_configuration_path(assigns(:room_configuration))
  end

  test "should show room_configuration" do
    get :show, id: @room_configuration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @room_configuration
    assert_response :success
  end

  test "should update room_configuration" do
    put :update, id: @room_configuration, room_configuration: { capacity: @room_configuration.capacity, name: @room_configuration.name, room_id: @room_configuration.room_id }
    assert_redirected_to room_configuration_path(assigns(:room_configuration))
  end

  test "should destroy room_configuration" do
    assert_difference('RoomConfiguration.count', -1) do
      delete :destroy, id: @room_configuration
    end

    assert_redirected_to room_configurations_path
  end
end
