class window.Stage
  _canvas = null
  _width = 0
  _height = 0
  _cx = 0
  _cy = 0
  _r = 0
  _nCars = 0
  _cars = null

  # r: a radius of the stage (in px)
  # numCars: a number of cars on the stage
  constructor: (canvas, r, numCars) ->
    this._canvas = canvas
    this._width = this._canvas.width
    this._height = this._canvas.height
    this._cx = this._width / 2.0
    this._cy = this._height / 2.0
    this._r = r
    this._nCars = numCars
    this._cars = new Array(this._nCars)
    for i in [0...this._nCars]
      this._cars[i] = new Car(0.002, (1.0 / this._nCars) * i)
    drawCars.call(@)
    setInterval(this.update, 1000 / 60)
    console.log 'finish initialize'

  update: () =>
    ctx = this._canvas.getContext('2d')
    ctx.beginPath()
    ctx.clearRect(0, 0, this._canvas.width, this._canvas.height)
    for i in [0...this._nCars]
      this._cars[i].move(this._cars[(i + 1) % this._nCars])
    drawCars.call(@)

  ### Properties ###
  r = () => this._r
  numCars = () => this._nCars

  drawCars = () ->
    for c in this._cars
      th = c.position() * 2 * Math.PI
      drawPoint.call(@,
        this._cx + this._r * Math.cos(th), this._cy + this._r * Math.sin(th), 2)

  drawPoint = (x, y, r) ->
    ctx = this._canvas.getContext('2d')
    ctx.beginPath()
    ctx.arc(x, y, r, 0, Math.PI * 2, false)
    ctx.fill()
