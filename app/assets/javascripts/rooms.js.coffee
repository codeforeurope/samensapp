# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->

  #Photo management
  $('#new_picture').fileupload()

  openPicture = ->
    $('#pictureModal').modal "show"

  onPictureClick = ->
    $('.open-picture').on 'click', (e) ->
      e.preventDefault()
      $('#carouselModal').data("picture-id", $(this).data("picture-id"))
      $('#carouselModal').modal "show"

  $('#carouselModal').on 'shown', (e) ->
    picture_id = $(this).data("picture-id")
    $('#carouselModal').load(window.location.pathname + "/pictures/"+ picture_id + "/carousel?active_picture_id=" + picture_id)

  onPictureEdit = ->
    $('.edit-picture').on 'click', (e) ->
      e.preventDefault()
      $('#pictureModal').data("picture-id", $(this).data("picture-id"))
      $('#pictureModal').modal "show"

  $('#pictureModal').on 'hide', (e) ->
    $('#pictures').load(window.location.pathname + "/pictures", onPictureEdit)

  $('#pictureModal').on 'shown', (e) ->
    $('#pictureModal').load(window.location.pathname + "/pictures/" + $(this).data("picture-id") + "/edit", (data, status, xhr) ->
      $('#pictureModal form').on 'ajax:success', (data, status, xhr) ->
        $('#pictureModal').modal 'hide'
    )


  # Configuration management
  attachSuccessCallback = ($modal)->
    $modal.find('form').on "ajax:success", (xhr, data, status)->
      $modal.modal "hide"


  attachErrorCallback = ($modal)->
    $modal.find('form').on "ajax:error", (xhr, data, status)->
      $modal.find('.modal-body').html data.responseText
      attachSuccessCallback($modal)
      attachErrorCallback($modal)

  refreshConfigTable = () ->
    $('#room_config_table').load($('#room_config_table').data("configurations-url"), null, attachAfterDeleteCallback)

  attachAfterDeleteCallback  = () ->
    $('#room_config_table a[data-method=delete]').on 'ajax:success', (data, textStatus, jqXHR)->
      refreshConfigTable()

  $('#new_room_config, #edit_room_config').on "shown", (e)->
    attachSuccessCallback($(this))
    attachErrorCallback($(this))

  $('#new_room_config .modal-footer .btn-primary').on "click", (e)->
    $('#new_room_config .modal-body form').trigger "submit"

  $('#edit_room_config .modal-footer .btn-primary').on "click", (e)->
    $('#edit_room_config .modal-body form').trigger "submit"

  $('#new_room_config, #edit_room_config').on "hide", (e)->
    $(this).removeData('modal')
    refreshConfigTable()


  #on Ready
  onPictureEdit()
  onPictureClick()
  attachAfterDeleteCallback()

