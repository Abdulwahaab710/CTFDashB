# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
load = ->
  add_field_btn = document.getElementById 'add-field-btn'

  number_of_elements_in_div = (id) ->
    document.getElementById(id).children.length

  if add_field?
    add_field = ->
      form_id = 'form-body'
      form = document.getElementById form_id

      last_key = document.getElementById(form_id).children[(number_of_elements_in_div form_id) - 2]
      last_value = document.getElementById(form_id).children[(number_of_elements_in_div form_id) - 1]
      if last_value.value != '' || last_key.value != ''
        key = document.createElement 'input'
        style = 'width: 49%; text-align: center;'
        key.name = 'key[]'
        key.style = "#{style} margin-right: 0.8%;"
        value = document.createElement 'input'
        value.name = 'value[]'
        value.style = style
        form.appendChild key
        form.appendChild value
        key.focus()
      else
        last_key.focus()

    add_field_btn.onclick = (e) => add_field()
    return
document.addEventListener 'DOMContentLoaded', load
