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

  afterEdit = ->
    $('#pictureCarousel').slider()
    onPictureEdit()

  $('#pictureModal').on 'hide', (e) ->
    picture_id = $(this).data("picture-id")
    $('#picturesCarousel').load(window.location.pathname + "/pictures?active_picture_id=" + picture_id, afterEdit)

  $('#pictureModal').on 'shown', (e) ->
    console.log($(this).data("picture-id"))
    $('#pictureModal').load(window.location.pathname + "/pictures/" + $(this).data("picture-id") + "/edit", (data, status, xhr) ->
      $('#pictureModal form').on 'ajax:success', (data, status, xhr) ->
        $('#pictureModal').modal 'hide'
    )