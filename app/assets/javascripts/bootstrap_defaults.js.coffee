jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip, [data-toggle=tooltip]").tooltip()
  $("a[rel=tooltip]").tooltip()
  $(".bootstrap-datepicker-component").datepicker({ format: "yyyy-mm-dd"}).on 'changeDate', (e) ->
    $(this).datepicker('hide')

  $('.bootstrap-timepicker-component input').timepicker({ showMeridian: false})