jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $(".datepicker").datepicker({ dateFormat: "yy-mm-dd" })