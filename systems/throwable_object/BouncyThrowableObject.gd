class_name BouncyThrowableObject
extends ThrowableObject


@export var bounce_force := 600.0

@onready var _bounceArea = $BounceArea


func _ready() -> void:
  super()
  _bounceArea.body_entered.connect(_on_BounceArea_body_entered)
  
  
  
func _physics_process(delta: float) -> void:
  super(delta)
  
  if _bounceArea.monitorable:
    return
  
  var collisions = get_slide_collision_count()
  if collisions > 0:
    _enable_bounce_area()
  #if collisions == 0:
    #return
  #for i in collisions:
    #var kinematicCollision = get_slide_collision(i)
    #if kinematicCollision.get_collider().collision_layer == 1:
      #_enable_bounce_area()
  

func _on_BounceArea_body_entered(bodyNode: CharacterBody2D) -> void:
  if not bodyNode:
    return
  
  bodyNode.velocity.y = -bounce_force
  _graphicsNode.play("bounce")
  await _graphicsNode.animation_finished
  _graphicsNode.play("default")


func _enable_bounce_area() -> void:
  _bounceArea.monitorable = true
  _bounceArea.monitoring = true


func _hit(kinematicCollision: KinematicCollision2D) -> void:
  pass
