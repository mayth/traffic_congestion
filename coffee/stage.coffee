class window.Stage
  @requestAnimationFrame: (callback) ->
    (window.requestAnimationFrame or
      window.mozRequestAnimationFrame or
      window.webkitRequestAnimationFrame or
      window.msRequestAnimationFrame or
      (f) -> window.setTimeout(f, 1000 / @fps)
    )(callback)

  CAR_SIZE = 2

  startTime: null
  currentFps: null
  isRunning: false

  generateCanvas: (width, height) ->
    @canvas = document.createElement('canvas')
    @canvas.width = @width
    @canvas.height = @height
    unsupportedText = document.createTextNode('Your browser doesn\'t support Canvas. Please upgrade the browser or use the other one.')
    @canvas.appendChild(unsupportedText)

  constructor: (@width, @height, opts = {}) ->
    @numCars = opts['numCars'] || 100
    @fps = opts['fps'] || 60
    @cx = opts['cx'] || @width / 2.0
    @cy = opts['cy'] || @height / 2.0
    @r = opts['r'] || (Math.min(@width, @height) * 0.9) / 2.0
    @targetSpeed = opts['targetSpeed'] || 0.002
    @cars = new Array(@numCars)
    @generateCanvas(@width, @height)
    @canvas.addEventListener('click', this.crash)
    @init()
    console.log 'finish initialize'

  init: =>
    d = 1.0 / @numCars
    @cars = new Array(@numCars)
    for i in [0...@numCars]
      @cars[i] = new Car(@targetSpeed, d * i,
        collisionThreshold: d * 0.5,
        acceleration: 0.00005
      )

  update: (now) =>
    @draw()
    for c,i in @cars
      c.update(@cars[(i + 1) % @numCars])
    if @isRunning
      Stage.requestAnimationFrame(this.update)

  draw: () =>
    ctx = @canvas.getContext('2d')
    ctx.beginPath()
    ctx.clearRect(0, 0, @canvas.width, @canvas.height)
    # @drawRoad()
    for c in @cars
      th = c.position * 2 * Math.PI
      col = { r: if (c.speed - @targetSpeed) < 0 then 255 else 0 }
      @drawPoint(@cx + @r * Math.cos(th), @cy + @r * Math.sin(th), CAR_SIZE, col)

  start: () =>
    @isRunning = true
    Stage.requestAnimationFrame(this.update)

  stop: () =>
    @isRunning = false

  crash: () =>
    tgt = Math.floor(Math.random() * (@numCars - 1))
    @cars[tgt].crash()
    console.log "crashed #{tgt}"
    tgt

  drawRoad: () =>
    ctx = @canvas.getContext('2d')
    ctx.beginPath()
    ctx.strokeStyle = "rgba(0,0,0, 0.5);"
    ctx.arc(@cx, @cy, @r + CAR_SIZE * 2, 0, Math.PI * 2, false)
    ctx.stroke()
    ctx.beginPath()
    ctx.arc(@cx, @cy, @r - CAR_SIZE * 2, 0, Math.PI * 2, false)
    ctx.stroke()

  drawPoint: (x, y, r, color = {}) =>
    cr = color['r'] || 0
    cg = color['g'] || 0
    cb = color['b'] || 0
    ca = color['a'] || 1.0
    ctx = @canvas.getContext('2d')
    ctx.beginPath()
    ctx.fillStyle = "rgba(#{cr},#{cg},#{cb},#{ca});"
    ctx.arc(x, y, r, 0, Math.PI * 2, false)
    ctx.fill()
