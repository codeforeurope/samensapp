# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#new_picture').fileupload
    dataType: "script"

    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png)$/i
      file = data.files[0]
      data.context = (tmpl("template-upload", file))
      $('#new_picture').append(data.context)
      data.submit()
      $('#progressModal').modal "show"

    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        $("div.upload").find('.bar').css('width', progress + '%')
    done: (e, data) ->
      $('#progressModal').modal "hide"
#        $("div.upload").hide()