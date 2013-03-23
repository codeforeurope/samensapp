jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $(".bootstrap-datepicker-component").datepicker({ format: "yyyy-mm-dd" })
  $('.bootstrap-timepicker-component input').timepicker({ showMeridian: false})