# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  attachSuccessCallback = ->
      $('#new_room_config').find('form').on "ajax:success", (xhr, data, status)->
        $('#new_room_config').modal "hide"

  attachErrorCallback = ->
      $('#new_room_config').find('form').on "ajax:error", (xhr, data, status)->
        $('#new_room_config .modal-body').html data.responseText
        attachSuccessCallback()
        attachErrorCallback()

  $('#new_room_config').on "shown", (e)->
    attachSuccessCallback()
    attachErrorCallback()

  $('#new_room_config .modal-footer .btn-primary').on "click", (e)->
    $('#new_room_config .modal-body form').trigger "submit"
