# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
load = ->
  add_field_btn = document.getElementById 'add-field-btn'

  add_field = ->
    form = document.getElementById 'form-body'
    key = document.createElement 'input'
    key.name = 'key[]'
    key.style = 'width: 49%;'
    value = document.createElement 'input'
    value.name = 'value[]'
    value.style = 'width: 49%;'
    form.appendChild key
    form.appendChild value

  add_field_btn.onclick = (e) => add_field()
  return
document.addEventListener 'DOMContentLoaded', load
