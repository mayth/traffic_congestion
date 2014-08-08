class window.Car
  constructor: (@speed, @position, opts = {}) ->
    @targetSpeed = opts['targetSpeed'] || @speed
    @collisionThreshold = opts['collisionThreshold'] || 0.0075
    @acceleration = opts['acceleration'] || 0.001
    @decelerationRate = opts['decelerationRate'] || 0.5

  collision: (a, b) =>
    Math.abs((a + 1.0) - b) <= @collisionThreshold or
      Math.abs(a - (b + 1.0)) <= @collisionThreshold or
      Math.abs(a - b) <= @collisionThreshold

  @coercePosition: (pos) =>
    if pos < 0
      pos + 1.0
    else if (pos - 1.0) > 0
      pos - 1.0
    else
      pos

  update: (frontCar) =>
    nextPosition = Car.coercePosition(@position + @speed)
    if this.collision(frontCar.position, nextPosition)
      @speed *= @decelerationRate
      nextPosition = Car.coercePosition(@position + @speed)
    else if (@speed - @targetSpeed) < 0.0
      @speed += @acceleration
      if (@targetSpeed - @speed) < 0.0
        @speed = @targetSpeed
      nextPosition = Car.coercePosition(@position + @speed)

    @position = nextPosition

  crash: () =>
    @speed = @targetSpeed * 0.1
