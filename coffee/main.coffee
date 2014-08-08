document.addEventListener('DOMContentLoaded', () ->
  stage = new Stage(document.getElementById('cv'), 100)

  Vue.filter('fixed', (value, digit) ->
    value.toFixed(digit)
  )

  cars = new Vue
    el: '#cars'
    data:
      cars: stage.cars

  stage.run()
)