class window.Car
  NEAR_THRESHOLD = 0.001

  _speed = 0.0
  _pos = 0.0
  _target_speed = 0.0

  constructor: (speed, pos) ->
    this._speed = speed
    this._pos = pos
    this._target_speed = speed

  speed: -> this._speed
  position: -> this._pos

  move: (frontCar) ->
    if Math.abs(frontCar.position() - this.position()) < NEAR_THRESHOLD
      this._speed -= 0.1
      this._speed = 0.0 if this._speed < 0.0
    else if (this._speed - this._target_speed) < 0.0
      this._speed += 0.1
      if (this._target_speed - this._speed) < 0.0
        this._speed = this._target_speed
    this._pos += this._speed
