document.addEventListener('DOMContentLoaded', () ->
  stage = new Stage(document.getElementById('cv'), 100)

  cars = new Vue
    el: '#cars'
    data:
      cars: stage.cars

  stage.run()
)