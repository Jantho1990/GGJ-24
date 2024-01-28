class_name ThrowableObject
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@export var movements : Array[ThrowableObjectMovement] = [] :
  set = _set_movements

var aiming := false

@onready var _graphicsNode = $Graphics
@onready var _visibilityNotifier = $VisibilityNotifier


func _ready() -> void:
  queue_redraw()
  _visibilityNotifier.screen_exited.connect(_on_VisibilityNotifier_screen_exited)
  if _graphicsNode is AnimatedSprite2D:
    _graphicsNode.play("default")


func _physics_process(delta: float) -> void:
  if aiming:
    queue_redraw()
    return
  
  #velocity = velocity.rotated(0)
  for throwableObjectMovement in movements:
    throwableObjectMovement.integrate_velocity(self, delta)
  
  #velocity = velocity.rotated(rotation)
  move_and_slide()
  var collisions = get_slide_collision_count()
  if collisions == 0:
    return
  for i in collisions:
    var collisionObject = get_slide_collision(i)
    if collisionObject.get_collider().has_method('explode'):
      collisionObject.get_collider().explode();
      _hit(collisionObject)
  #queue_redraw()
  #print('DBG: velocity ', velocity)


func _draw() -> void:
  if not $Graphics:
    return
  if not aiming:
    return
  #return
  #draw_circle(Vector2.ZERO, 5.0, Color(1, 0, 0))
  #return
  var points = _get_predicted_movement(1.0)
  #return
  #draw_polygon(points, [Color(0, 1, 0)])
  for point in points:
    draw_circle(point, 2.0, Color(0, 1, 0))
    #print('DBG: drawing point %s' % [point])
  #breakpoint


func _on_VisibilityNotifier_screen_exited() -> void:
  queue_free()


func _set_movements(value: Array[ThrowableObjectMovement]) -> void:
  movements = []
  for throwableObjectMovement in value:
    movements.push_back(throwableObjectMovement.duplicate(true))


func _get_predicted_movement(prediction_duration_seconds: float) -> PackedVector2Array:
  _reset_movements()
  var ret = []
  var simulatedBody = CharacterBody2D.new()
  simulatedBody.velocity = velocity
  #simulatedBody.rotation = global_rotation
  #print('DBG: global_rotation ', global_rotation)
  #simulatedBody.aiming = true
  
  var sim_delta := (1.0 / 10.0) * 1000.0
  #var derp = prediction_duration_seconds * 1000.0 / 60.0
  #print('DBG: drawing predicted movement... %s %s' % [prediction_duration_seconds, sim_delta])
  
  #for i: float in range(0, prediction_duration_seconds * 1000.0, sim_delta):
  var i = 0.0
  var sim_position = Vector2.ZERO
  while i < prediction_duration_seconds * 1000.0:
    i += sim_delta
    for throwableObjectMovement in movements:
      throwableObjectMovement.integrate_velocity(simulatedBody, sim_delta / 1000.0)
    var predicted_velocity = simulatedBody.velocity
    predicted_velocity *= get_physics_process_delta_time()
    sim_position += predicted_velocity
    ret.push_back(sim_position)
    #print('DBG: draw update ', sim_position, ' ', predicted_velocity)
  return ret


func _hit(_collisionObject: KinematicCollision2D) -> void:
  queue_free()


func _reset_movements() -> void:
  for throwableObjectMovement in movements:
    throwableObjectMovement.reset()


func aim() -> void:
  aiming = true
  
  
func aim_release() -> void:
  aiming = false
  queue_redraw()
  _reset_movements()
