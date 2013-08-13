jQuery ->
  $(".building-select").on "change", (e)->
    room_select = $(this).parent().parent().next().find(".room-select")
    building_id = $(this).val()
    url = "/rooms_in_building/#{building_id}"
    console.log url
    $.get(url, (data, xhr, status) ->
      room_select.html(data).prop("disabled", false)

    )
#      select_wrapper.load(url)

  $("#add-room").on 'click', (e) ->
    e.preventDefault()
    room_select_wrapper = $("#rooms-container")
    booking_request_id = $(this).data("booking-request-id")
    console.log(booking_request_id)
    url = "/rooms_for_event?booking_request_id=#{booking_request_id}"
    console.log url
    $.get(url, (data, xhr, status) ->
      room_select_wrapper.append($(data).html())
      onBuildingChange()
    )
#