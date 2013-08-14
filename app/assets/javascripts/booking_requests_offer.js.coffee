toggleRemoveRoomButtons = (add = false)->
  #  if buttons.length < 2
  if add
    $("form .remove-room").removeClass("hidden")
  else
    if $("form .remove-room:visible").length < 2
      $("form .remove-room:visible").addClass("hidden")


jQuery ->
  updateSubTotal = ($source) ->
    $source.parentsUntil("fieldset").parent().first()



  $("form").on "change", ".building-select", (e)->
    room_select = $(this).parent().parent().next().find(".room-select")
    building_id = $(this).val()
    url = "/rooms_in_building/#{building_id}"
    $.get url, (data, xhr, status) ->
      room_select.html(data).prop("disabled", false)
      room_select.change()


  $("form").on "change", ".room-select", (e)->
    room_id = $(this).val()
    url = $(this).data("rooms-url") + "/#{room_id}/prices.json"
    $fieldset = $(this).parentsUntil("fieldset").parent().first()
    $.ajax({
      url: url,
      dataType: "json",
      contentType: "application/json",
      success:  (data, xhr, status) ->
        $fieldset.find('.tariff [data-toggle=buttons-radio]').data("tariffs", data)
        $fieldset.find('.tariff .btn').removeClass("disabled")

    })
    $.get url,

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

  $('form').on 'click', '[data-toggle=buttons-radio] .btn', (e)->
    tariff = $(this).parent().data("tariffs")[$(this).data("tariff")]
    $fieldset = $(this).parentsUntil("fieldset").parent().first()
    $fieldset.find("input[name*=price]").val(tariff).change()


  $('form').on 'change', "input[name*=price]", (e) ->
    updateSubTotal $(this)



