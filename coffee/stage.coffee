class window.Stage
  @requestAnimationFrame: (callback) ->
    (window.requestAnimationFrame or
      window.mozRequestAnimationFrame or
      window.webkitRequestAnimationFrame or
      window.msRequestAnimationFrame or
      (f) -> window.setTimeout(f, 1000 / @fps)
    )(callback)

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
      @cars[i] = new Car(0.002, d * i,
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
    for c in @cars
      th = c.position * 2 * Math.PI
      @drawPoint(@cx + @r * Math.cos(th), @cy + @r * Math.sin(th), 2)
      #x = c.position * @width
      #@drawPoint(x, @cy, 2)

  crash: () =>
    tgt = Math.floor(Math.random() * (@numCars - 1))
    @cars[tgt].crash()
    console.log "crashed #{tgt}"
    tgt

  drawPoint: (x, y, r) =>
    ctx = @canvas.getContext('2d')
    ctx.beginPath()
    ctx.arc(x, y, r, 0, Math.PI * 2, false)
    ctx.fill()
