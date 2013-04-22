# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#$(document).on 'map:ready', ->
#  addHoverHandlers()
#
#addHoverHandlers = ->
#  # m is Gmap4Rails marker, doc in gmaps4rails.base.js.coffee
#  for m in Gmaps.map.markers
#    # marker is a Google Maps Marker
#    # https://developers.google.com/maps/documentation/javascript/reference#Marker
#    marker = m.serviceObject
#
#    console.log marker.getPosition().toString()
#    # Show the infowindow when user mouses-in
#    google.maps.event.addListener marker, "click", ->
#      console.log marker.getPosition().toString()
#      # Loop on Gmaps.map.markers and find the one using this
#      for m2 in Gmaps.map.markers
#        if m2.serviceObject == this
#          m2.infowindow.open m2.serviceObject.map, m2.serviceObject
#
## Hide the infowindow when user mouses-out
##    google.maps.event.addListener marker, "mouseout", ->
##      m.infowindow.close()