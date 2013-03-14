# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#copy_personal_info').change (e)->
    if $(this).prop('checked') == true
      $("#booking_request_contact_person").val $("#booking_request_submitter_attributes_name").val()
      $("#booking_request_contact_email").val $("#booking_request_submitter_attributes_email").val()
      $("#booking_request_contact_phone").val $("#booking_request_submitter_attributes_phone").val()
      $("#booking_request_organization_address").val $("#booking_request_submitter_attributes_address").val()
  $("#create_account").change (e)->
    if $(this).prop('checked') == true
      $(this).parent().parent().find("input[type=password]").parent().show()
    else
      $(this).parent().parent().find("input[type=password]").parent().hide()
