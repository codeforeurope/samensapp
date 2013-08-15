toggleRemoveRoomButtons = (add = false)->
  #  if buttons.length < 2
  if add
    $("form .remove-room").removeClass("hidden")
  else
    if $("form .remove-room:visible").length < 2
      $("form .remove-room:visible").addClass("hidden")


jQuery ->
  updateRoomTotal = () ->
    roomTotal = 0.00
    $("form input[name*=sub_total]:visible").each (item)->
      roomTotal += parseFloat($(this).val())
    $("form input[name*=room_total]").val(Number(roomTotal).toFixed(2))

  updateSubTotal = ($source) ->
    hour_block = parseInt($("form").data("hour-block"))
    $fieldset = $source.parentsUntil("fieldset").parent().first()
    $event_date = $fieldset.find("input[name*=event_date]")
    $start_time = $fieldset.find("input[name*=start_time]")
    $end_time = $fieldset.find("input[name*=end_time]")
    $units = $fieldset.find("input[name*=units]")

    $price = $fieldset.find("input[name*=price]")
    $sub_total = $fieldset.find("input[name*=sub_total]")

    hours = (Date.parse($event_date.val() + " " + $end_time.val()) - Date.parse($event_date.val() + " " + $start_time.val())) / 3600000
    units = Math.ceil(hours / hour_block)
    $units.val(units)
    $sub_total.val((units * hour_block * $price.val()).toFixed(2))
    updateRoomTotal()


  $("form").on "change", ".building-select", (e)->
    room_select = $(this).parent().parent().next().find(".room-select")
    building_id = $(this).val()
    url = "/rooms_in_building/#{building_id}"
    $.get url, (data, xhr, status) ->
      room_select.html(data).prop("disabled", false)
      room_select.change()


  $("form").on "change", ".room-select", (e)->
    $source = $(this)
    room_id = $source.val()
    url = $source.data("rooms-url") + "/#{room_id}/prices.json"
    $fieldset = $source.parentsUntil("fieldset").parent().first()
    $.ajax({
      url: url,
      dataType: "json",
      contentType: "application/json",
      success: (data, xhr, status) ->
        $fieldset.find('.tariff [data-toggle=buttons-radio]').data("tariffs", data)
        $fieldset.find('.tariff .btn').removeClass("disabled")
        updateSubTotal($source)
    })

  $("form").on 'click', ".add-room", (e) ->
    e.preventDefault()
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $("#rooms-container").append($(this).data('fields').replace(regexp, time))
    applyDateAndTimePicker()
    toggleRemoveRoomButtons(true)

  $('form').on 'click', '.remove-room', (e) ->
    e.preventDefault()
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    toggleRemoveRoomButtons()
    updateRoomTotal()

  $('form').on 'click', '[data-toggle=buttons-radio] .btn', (e)->
    tariff = $(this).parent().data("tariffs")[$(this).data("tariff")]
    $fieldset = $(this).parentsUntil("fieldset").parent().first()
    $fieldset.find("input[name*=price]").val(Number(tariff).toFixed(2)).change()


  $('form').on 'change', "input[name*=price]", (e) ->
    updateSubTotal $(this)

  $('form').on 'changeTime.timepicker', ".bootstrap-timepicker-component input", (e)->
    $fieldset = $(this).parentsUntil("fieldset").parent().first()
    if !$fieldset.find("select[name*=room_id]").val()
      return
    $event_date = $fieldset.find("input[name*=event_date]")
    $start_time = $fieldset.find("input[name*=start_time]")
    $end_time = $fieldset.find("input[name*=end_time]")
    if Date.parse($event_date.val() + " " + $start_time.val()) > Date.parse($event_date.val() + " " + $end_time.val())
      $end_time.val($start_time.val())

    updateSubTotal($(this))

