require 'test_helper'

class BookingRequestsControllerTest < ActionController::TestCase
  setup do
    @booking_request = booking_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:booking_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create booking_request" do
    assert_difference('BookingRequest.count') do
      post :create, booking_request: { catering_needs: @booking_request.catering_needs, description: @booking_request.description, end_time: @booking_request.end_time, equipment_needs: @booking_request.equipment_needs, notes: @booking_request.notes, people: @booking_request.people, start_time: @booking_request.start_time, status: @booking_request.status }
    end

    assert_redirected_to booking_request_path(assigns(:booking_request))
  end

  test "should show booking_request" do
    get :show, id: @booking_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @booking_request
    assert_response :success
  end

  test "should update booking_request" do
    put :update, id: @booking_request, booking_request: { catering_needs: @booking_request.catering_needs, description: @booking_request.description, end_time: @booking_request.end_time, equipment_needs: @booking_request.equipment_needs, notes: @booking_request.notes, people: @booking_request.people, start_time: @booking_request.start_time, status: @booking_request.status }
    assert_redirected_to booking_request_path(assigns(:booking_request))
  end

  test "should destroy booking_request" do
    assert_difference('BookingRequest.count', -1) do
      delete :destroy, id: @booking_request
    end

    assert_redirected_to booking_requests_path
  end
end
