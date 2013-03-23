# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#new_picture').fileupload

  openPicture = ->
    $('#pictureModal').modal "show"

  onPictureClick = ->
    $('.open-picture').on 'click', (e) ->
      e.preventDefault()
      console.log($(this).data("picture-id"))
      $('#carouselModal').data("picture-id", $(this).data("picture-id"))
      $('#carouselModal').modal "show"

  onPictureClick()

  $('#carouselModal').on 'shown', (e) ->
    console.log($(this).data("picture-id"))
    picture_id = $(this).data("picture-id")
    $('#carouselModal').load(window.location.pathname + "/pictures/"+ picture_id + "/carousel?active_picture_id=" + picture_id)
#    $('#carouselModal').load(window.location.pathname + "/pictures/" + $(this).data("picture-id") + "/edit", (data, status, xhr) ->
#      $('#pictureModal form').on 'ajax:success', (data, status, xhr) ->
#        $('#pictureModal').modal 'hide'
#    )

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
    $('#pictureModal').load(window.location.pathname + "/pictures/" + $(this).data("picture-id") + "/edit", (data, status, xhr) ->
      $('#pictureModal form').on 'ajax:success', (data, status, xhr) ->
        $('#pictureModal').modal 'hide'
    )