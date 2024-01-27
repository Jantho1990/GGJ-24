class_name ThrowableObject
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var movements : Array[ThrowableObjectMovement] = []


func _ready() -> void:
  queue_redraw()


func _physics_process(delta: float) -> void:
  for throwableObjectMovement in movements:
    throwableObjectMovement.integrate_velocity(self)
  
  move_and_slide()
  #queue_redraw()
  print('DBG: velocity ', velocity)


func _draw() -> void:
  if not $Graphics:
    return
  #return
  draw_circle(Vector2.ZERO, 5.0, Color(1, 0, 0))
  #return
  var points = _get_predicted_movement(1.0)
  #return
  #draw_polygon(points, [Color(0, 1, 0)])
  for point in points:
    draw_circle(point, 2.0, Color(0, 1, 0))
    print('DBG: drawing point %s' % [point])


func _get_predicted_movement(prediction_duration_seconds: float) -> PackedVector2Array:
  var ret = []
  var simulatedBody = CharacterBody2D.new()
  simulatedBody.velocity = velocity
  
  var sim_delta := (1.0 / 10.0) * 1000.0
  #var derp = prediction_duration_seconds * 1000.0 / 60.0
  print('DBG: drawing predicted movement... %s %s' % [prediction_duration_seconds, sim_delta])
  
  #for i: float in range(0, prediction_duration_seconds * 1000.0, sim_delta):
  var i = 0.0
  var sim_position = Vector2.ZERO
  while i < prediction_duration_seconds * 1000.0:
    i += sim_delta
    for throwableObjectMovement in movements:
      throwableObjectMovement.integrate_velocity(simulatedBody)
    var predicted_velocity = simulatedBody.velocity
    predicted_velocity *= get_physics_process_delta_time()
    sim_position += predicted_velocity
    ret.push_back(sim_position)
    print('DBG: draw update ', sim_position, ' ', predicted_velocity)
  return ret


func _old_physics_process(delta):
  # Add the gravity.
  if not is_on_floor():
    velocity.y += 98.0 * delta

  # Handle jump.
  if Input.is_action_just_pressed("ui_accept") and is_on_floor():
    velocity.y = JUMP_VELOCITY

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  var direction = Input.get_axis("ui_left", "ui_right")
  if direction:
    velocity.x = direction * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)

  move_and_slide()
