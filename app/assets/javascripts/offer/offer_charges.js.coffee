jQuery ->
  toggleChargesTable = (add = false)->
    #  if buttons.length < 2
    if add
      $("#extras-container table").removeClass("hidden")
    else
      if  $("#extras-container tbody tr:visible").length < 1
        $("#extras-container table").addClass("hidden")

  updateExtrasTotal = ()->
    extras_total = 0
    $line_totals = $("#extras-container tbody").find("input[name*=total]:visible")
    $extras_total = $("#extras-container input[name*=extras_total]")
    $line_totals.each (i, input)->
      extras_total += Number($(input).val())

    $extras_total.val(extras_total.toFixed(2))
    updateGrandTotal()


  $("form").on 'click', ".add-charge", (e) ->
    e.preventDefault()
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')


    $("#extras-container tbody").append($(this).data('fields').replace(regexp, time))
    toggleChargesTable(true)

  $('form').on 'click', '.remove-charge', (e) ->
    e.preventDefault()
    $row = $(this).parent().parent()
    $row.addClass("hidden")
    $row.find("input[name*=_destroy]").val(true)
    toggleChargesTable()
    updateExtrasTotal()

  $('form').on 'change', "#extras-container input[name*=price], #extras-container input[name*=units]", (e) ->
    $row = $(this).parents("tr")
    $price = $row.find("input[name*=price]")
    $units = $row.find("input[name*=units]")
    $line_total = $row.find("input[name*=total]")
    $line_total.val(Number($price.val() * $units.val()).toFixed(2))
    updateExtrasTotal()