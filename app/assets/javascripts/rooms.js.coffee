# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  attachSuccessCallback = ($modal)->
    $modal.find('form').on "ajax:success", (xhr, data, status)->
      $modal.modal "hide"


  attachErrorCallback = ($modal)->
    $modal.find('form').on "ajax:error", (xhr, data, status)->
      $modal.find('.modal-body').html data.responseText
      attachSuccessCallback($modal)
      attachErrorCallback($modal)

  refreshConfigTable = () ->
    $('#room_config_table').load($('#room_config_table', null, attachAfterDeleteCallback).data "configurations-url")

  attachAfterDeleteCallback  = () ->
    $('#room_config_table a[data-method=delete]').on 'ajax:success', (data, textStatus, jqXHR)->
      refreshConfigTable()

  $('#new_room_config, #edit_room_config').on "shown", (e)->
    attachSuccessCallback($(this))
    attachErrorCallback($(this))

  $('#new_room_config .modal-footer .btn-primary').on "click", (e)->
    $('#new_room_config .modal-body form').trigger "submit"

  $('#edit_room_config .modal-footer .btn-primary').on "click", (e)->
    console.log('I am here')
    $('#edit_room_config .modal-body form').trigger "submit"

  $('#new_room_config, #edit_room_config').on "hide", (e)->
    $(this).removeData('modal')
    refreshConfigTable()

  attachAfterDeleteCallback()