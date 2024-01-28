class_name HomingThrowableObject
extends ThrowableObject


# Get nodes in homing_targets group
# Filter to ones that are on-screen
# If there are > 1 (more than just the player)
# - Home in on closest non-player target
# Else if there is only 1 node in the group (the player)
# - Home on the player, but in a way that the player can dodge
# While aiming, use UI to show which target is being homed in on

@export var homing_speed := 500.0
@export var homing_delay := 0.5

var homing_in := false

var _homing_targets := []
var _lockedTarget: Node2D

@onready var _homingTimer = Timer.new()


func _ready() -> void:
  super()
  _homingTimer.one_shot = true
  add_child(_homingTimer)
  _homingTimer.timeout.connect(_on_HomingTimer_timeout)


func _physics_process(delta: float) -> void:
  if homing_in:
    _move_to_target()
  else:
    _acquire_targets()
  super(delta)
  

func _on_HomingTimer_timeout() -> void:
  _lock_in()
  
  
func _acquire_targets() -> void:
  var all_homing_targets = get_tree().get_nodes_in_group('homing_targets')
  _homing_targets = []
  for homingTarget in all_homing_targets:
    if _is_valid_homing_target(homingTarget):
      _homing_targets.push_back(homingTarget)
  
  

func _home_on_closest_target(targetNode: Node2D) -> void:
  _lockedTarget = targetNode
  

func _home_on_player(playerNode: Node2D) -> void:
  # Create a node representing the player's current position.
  # We track that instead of the player to give the player a chance to dodge.
  var playerPos = Marker2D.new()
  playerPos.global_position = playerNode.global_position
  playerNode.get_parent().add_child(playerPos)
  _lockedTarget = playerPos


func _integrate_movement_velocities(bodyNode: CharacterBody2D, delta: float) -> void:
  if homing_in:
    return
  
  super(bodyNode, delta)


func _hit(kinematicCollision: KinematicCollision2D) -> void:
  super(kinematicCollision)
  
  if _lockedTarget is Marker2D:
    _lockedTarget.queue_free()


func _is_valid_homing_target(targetNode: Node2D) -> bool:
  if targetNode.is_in_group('player'):
    return true
  var visibilityNotifier = targetNode.get_node('VisibilityNotifier')
  if visibilityNotifier and visibilityNotifier.is_on_screen():
    return true
  
  return false


func _lock_in() -> void:
  homing_in = true
  _graphicsNode.play('homing')
  if _homing_targets.size() > 1: # It's not just the player
    var closestTarget: Node2D
    for homingTarget in _homing_targets:
      if homingTarget.is_in_group('player'):
        continue
      if closestTarget and global_position.distance_to(homingTarget.global_position) < global_position.distance_to(closestTarget.global_position):
        closestTarget = homingTarget
      else:
        closestTarget = homingTarget
    _home_on_closest_target(closestTarget)
  elif _homing_targets.size() == 1: # It's just the player
    _home_on_player(_homing_targets[0])
  else: # We have no targets, fall back.
    printerr('DBG: Homing pigeon has no targets, killing it.')
    queue_free()
    
  
func _move_to_target() -> void:
  var direction_to = global_position.direction_to(_lockedTarget.global_position)
  velocity += direction_to * homing_speed


func aim_release() -> void:
  super()
  _homingTimer.start(homing_delay)
