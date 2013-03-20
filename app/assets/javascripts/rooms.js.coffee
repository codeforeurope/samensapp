# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#new_picture').fileupload

  onPictureEdit = ->
    $('.edit-picture').on 'click', (e) ->
      e.preventDefault()
      $('#pictureModal').data("picture-id", $(this).data("picture-id"))
      $('#pictureModal').modal "show"

  onPictureEdit()

  $('#pictureModal').on 'hide', (e) ->
    $('#pictures').load(window.location.pathname + "/pictures", onPictureEdit)

  $('#pictureModal').on 'shown', (e) ->
    console.log($(this).data("picture-id"))
    $(this).find('.modal-body').load(window.location.pathname + "/pictures/" + $(this).data("picture-id") + "/edit", (data, status, xhr) ->
      $('#pictureModal form').on 'ajax:success', (data, status, xhr) ->
        $('#pictureModal').modal 'hide'
    )