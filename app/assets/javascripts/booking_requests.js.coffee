# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  # copy personal info
  $('#copy_personal_info').change (e)->
    if $(this).prop('checked') == true
      $("#booking_request_contact_person").val $("#booking_request_submitter_attributes_name").val()
      $("#booking_request_contact_email").val $("#booking_request_submitter_attributes_email").val()
      $("#booking_request_contact_phone").val $("#booking_request_submitter_attributes_phone").val()
      $("#booking_request_organization_address").val $("#booking_request_submitter_attributes_address").val()

  #create password
  $("#booking_request_submitter_attributes_create_account").change((e)->
    if $(this).prop('checked') == true
      $(this).parent().parent().parent().find("input[type=password]").parent().parent().show()
    else
      $(this).parent().parent().parent().find("input[type=password]").parent().parent().hide()
  ).change()

  #edit profile
  $('.edit-profile').click (e)->
    e.preventDefault()


  ## Disable submitter fields on load
  $('#new_booking_request').bind 'disable', (e)->
    $(this).find('fieldset.submitter').find('input, textarea').each  (index,item)->

      if $(item).val() and $(item).hasClass('lockable')
        $(item).prop('readonly', true)
#      console.log(item, index)


  ###
  # Modal dialog to lookup users
  ###
  #$email_field = $('#booking_request_submitter_attributes_email')
  $lookup_modal = $("#lookup_users_modal")
  $email_field_in_modal = $("#lookup_users_modal .search input")
  $search_button_in_modal = $("#lookup_users_modal .search button")
  $results_area = $("#lookup_users_modal .modal-body .results")
  user_lookup_url ="/booking_requests/find_user_by_email"

  # function: showEmailLookup - shows the lookup dialog
  showEmailLookup = (email)->
    $email_field_in_modal.val(email)
    $lookup_modal.modal('show')

  # function: launchEmailLookup - starts the search
  launchEmailLookup = ()->
    $results_area.load(user_lookup_url + "?" + $.param({email: $email_field_in_modal.val()}) , afterEmailLookupComplete)

  # function: afterEmailLookupComplete - callback executed after results loaded
  afterEmailLookupComplete = (data, textStatus, xhr)->
    $results_area.find('button').one 'click', onSelectLookupUser

  # function: onSelectLookupUser
  onSelectLookupUser = (e)->
    $("fieldset.submitter").load("/booking_requests/new?" + $.param({submitter_id: $(this).data("submitter-id")}) + " fieldset.submitter",onSelectLookupUserSuccess)


  # function: onSelectLookupUserSuccess
  onSelectLookupUserSuccess = (data, textStatus, xhr)->
    $lookup_modal.modal 'hide'
    $('#new_booking_request').trigger 'disable'



  ## other trigger from the button is connected via bootstrap url setup


  ## Triggers for launching search
  # 1. after the dialog is shown
  $lookup_modal.bind 'shown', (e)->
    launchEmailLookup()


  $search_button_in_modal.click (e)->
    e.preventDefault()
    launchEmailLookup()

  $email_field_in_modal.keydown (e)->
    if e.keyCode == 13
      e.preventDefault()
      launchEmailLookup()

  $("a[rel=tooltip]").tooltip()

  if $('#requests_chart').length
    Morris.Line
      element: 'requests_chart'
      data: $('#requests_chart').data('requests')
      xkey: 'created_at'
      ykeys: ['number']
      labels: ['Number of requests']
