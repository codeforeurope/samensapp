jQuery ->
  options = {
    header:{left: '', center: '',  right: ''},
    defaultView: 'agendaDay',
    selectable: true,
    selectHelper: true,
    editable: true,
    allDaySlot: false,
    minTime: "9:00",
    maxTime: "22:00",
#    slotMinutes: 15,
    axisFormat: "H:mm",
    axisFormat: "H:mm",
    select: (start, end, allDay) ->
      console.log(start, end, allDay)
  }

  $('.full-calendar').fullCalendar(options)

  $("#building").change (e)->
#    console.log("changed", e, $(this).val())
    select_wrapper = $(this).parent().next()
    building_id = $(this).val()
    url = "/rooms_in_building?building_id=#{building_id}"
    console.log url

    select_wrapper.load(url)
