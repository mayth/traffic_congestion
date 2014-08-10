$ -> 
  width = 400
  height = 400
  canvasContainer = $('#cvContainer')

  Vue.filter('fixed', (value, digit) ->
    value.toFixed(digit)
  )

  stage = new Stage(width, height, options)

  options = new Vue
    el: '#options'
    data:
      numCars: 100
      targetSpeed: 0.002

  cars = new Vue
    el: '#cars'
    data:
      cars: stage.cars

  applyStageOptions = () =>
    stage.numCars = Number(options.$data.numCars)
    stage.targetSpeed = Number(options.$data.targetSpeed)

  controls = {
    pause: $('#controls button[name="pause"]'),
    start: $('#controls button[name="start"]'),
    reset: $('#controls button[name="reset"]')
  }

  controls.pause.click ->
    stage.stop()
    controls.pause.attr('disabled', true)
    controls.pause.toggleClass('pure-button-disabled')
    controls.start.removeAttr('disabled')
    controls.start.toggleClass('pure-button-disabled')

  controls.start.click ->
    stage.start()
    controls.pause.removeAttr('disabled')
    controls.pause.toggleClass('pure-button-disabled')
    controls.start.attr('disabled', true)
    controls.start.toggleClass('pure-button-disabled')

  controls.reset.click ->
    stage.stop()
    setTimeout(->
      applyStageOptions()
      stage.init()
      cars.$data = { cars: stage.cars }
      stage.start()
      controls.pause.removeAttr('disabled')
      controls.pause.removeClass('pure-button-disabled')
      controls.start.attr('disabled', true)
      controls.start.addClass('pure-button-disabled')
    , 100)

  canvasContainer.append(stage.canvas)

  stage.start()
  controls.pause.removeAttr('disabled')
  controls.pause.removeClass('pure-button-disabled')
  controls.start.attr('disabled', true)
  controls.start.addClass('pure-button-disabled')
