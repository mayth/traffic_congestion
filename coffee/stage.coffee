class window.Stage
  @requestAnimationFrame: (callback) ->
    (window.requestAnimationFrame or
      window.mozRequestAnimationFrame or
      window.webkitRequestAnimationFrame or
      window.msRequestAnimationFrame or
      (f) -> window.setTimeout(f, 1000 / @fps)
    )(callback)

  CAR_SIZE = 2
  TARGET_SPEED = 0.002

  startTime: null
  currentFps: null

  constructor: (@canvas, @numCars = 100, @fps = 60, r = null, cx = null, cy = null) ->
    @width = @canvas.width
    @height = @canvas.height
    @cx = cx || @width / 2.0
    @cy = cy || @height / 2.0
    @r = r || (Math.min(@width, @height) * 0.9) / 2.0
    @cars = new Array(@numCars)
    d = 1.0 / @numCars
    for i in [0...@numCars]
      @cars[i] = new Car(TARGET_SPEED, d * i,
        collisionThreshold: d * 0.5,
        acceleration: 0.00005
      )
    @canvas.addEventListener('click', this.crash)
    console.log 'finish initialize'

  run: () =>
    Stage.requestAnimationFrame(this.update)

  update: (now) =>
    @draw()
    for c,i in @cars
      c.update(@cars[(i + 1) % @numCars])
    Stage.requestAnimationFrame(this.update)

  draw: () =>
    ctx = @canvas.getContext('2d')
    ctx.beginPath()
    ctx.clearRect(0, 0, @canvas.width, @canvas.height)
    # @drawRoad()
    for c in @cars
      th = c.position * 2 * Math.PI
      col = { r: if (c.speed - TARGET_SPEED) < 0 then 255 else 0 }
      @drawPoint(@cx + @r * Math.cos(th), @cy + @r * Math.sin(th), CAR_SIZE, col)

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
