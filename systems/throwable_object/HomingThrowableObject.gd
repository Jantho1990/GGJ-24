class_name HomingThrowableObject
extends ThrowableObject

signal homing_target_identified(homingTarget)


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
var dead := false

var _homing_targets := []
var _lockedTarget: Node2D

@onready var _homingTimer = Timer.new()


func _ready() -> void:
  GlobalSignal.add_emitter('homing_target_identified', self)
  super()
  _homingTimer.one_shot = true
  add_child(_homingTimer)
  _homingTimer.timeout.connect(_on_HomingTimer_timeout)


var DBG_is_zombie_pigeon := false
func _physics_process(delta: float) -> void:
  if dead:
    return
  if DBG_is_zombie_pigeon:
    push_error('HomingThrowableObject._physics_process(): Zombie object detected!')
    #queue_free()
  if homing_in:
    _move_to_target()
  elif aiming:
    _acquire_targets()
    _lockedTarget = _get_closest_target_to_player()
    homing_target_identified.emit(_lockedTarget)
  super(delta)
  if homing_in and not Global.object_exists(_lockedTarget): # Target was lost/destroyed. Destroy the throwable!
    _hit(null)
    DBG_is_zombie_pigeon = true
  if Global.object_exists(_lockedTarget) and _lockedTarget is Marker2D and global_position.distance_to(_lockedTarget.global_position) < 10.0:
    _hit(null)


func _process_collisions() -> void:
  var collisions = get_slide_collision_count()
  if collisions == 0:
    return
  for i in collisions:
    var collisionObject = get_slide_collision(i)
    var colliderObject = collisionObject.get_collider()
    if colliderObject.has_method('explode'):
      colliderObject.explode();
      _hit(collisionObject)
    elif (homing_in and colliderObject == get_tree().get_nodes_in_group('player')[0]):
      colliderObject.get_hit()
      _hit(collisionObject)
  

func _on_HomingTimer_timeout() -> void:
  _lock_in()
  
  
func _acquire_targets() -> void:
  var all_homing_targets = get_tree().get_nodes_in_group('homing_targets')
  _homing_targets = []
  for homingTarget in all_homing_targets:
    if _is_valid_homing_target(homingTarget):
      _homing_targets.push_back(homingTarget)
  

func _home_on_closest_target(targetNode: Node2D) -> void:
  #_lockedTarget = targetNode
  homing_target_identified.emit(_lockedTarget)
  

func _home_on_player(playerNode: Node2D) -> void:
  # Create a node representing the player's current position.
  # We track that instead of the player to give the player a chance to dodge.
  var playerPos = Marker2D.new()
  playerPos.global_position = playerNode.global_position
  playerNode.get_parent().add_child(playerPos)
  _lockedTarget = playerPos
  # Reduce speed slightly.
  homing_speed = homing_speed - (homing_speed / 1.25)
  homing_target_identified.emit(playerPos)


func _get_closest_target() -> Node2D:
  if _homing_targets.size() > 1: # It's not just the player
    var closestTarget: Node2D
    for homingTarget in _homing_targets:
      if homingTarget.is_in_group('player'):
        continue
      if closestTarget and global_position.distance_to(homingTarget.global_position) < global_position.distance_to(closestTarget.global_position):
        closestTarget = homingTarget
      elif not closestTarget:
        closestTarget = homingTarget
    return closestTarget
  elif _homing_targets.size() == 1: # It's just the player
    return _homing_targets[0]
  return null
  

func _get_closest_target_to_player() -> Node2D:
  var playerNode = get_tree().get_nodes_in_group('player')[0] # Hope the player always exists!
  
  if _homing_targets.size() > 1: # It's not just the player
    var closestTarget: Node2D
    for homingTarget in _homing_targets:
      if not Global.object_exists(homingTarget):
        continue
      if homingTarget.is_in_group('player'):
        continue
      if closestTarget and playerNode.global_position.distance_to(homingTarget.global_position) < playerNode.global_position.distance_to(closestTarget.global_position):
        closestTarget = homingTarget
      elif not closestTarget:
        closestTarget = homingTarget
    return closestTarget
  elif _homing_targets.size() == 1: # It's just the player
    return _homing_targets[0]
  return null


func _integrate_movement_velocities(bodyNode: CharacterBody2D, delta: float) -> void:
  if homing_in:
    return
  
  super(bodyNode, delta)


func _hit(kinematicCollision: KinematicCollision2D) -> void:
  #super(kinematicCollision)
  
  homing_target_identified.emit(null)
  
  if not Global.object_exists(_lockedTarget):
    _graphicsNode.play('explode')
    print('DBG: homing pigeon should explode soon')
    dead = true
    velocity = Vector2.ZERO
    await _graphicsNode.animation_finished
    queue_free()
    return
  
  if _lockedTarget is Marker2D:
    _lockedTarget.queue_free()
    
  if kinematicCollision:
    queue_free()
    return
  
  _graphicsNode.play('explode')
  dead = true
  print('DBG: homing pigeon should explode soon')
  await _graphicsNode.animation_finished
  queue_free()


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
  #if _homing_targets.size() > 1: # It's not just the player
    #var closestTarget: Node2D
    #for homingTarget in _homing_targets:
      #if not Global.object_exists(homingTarget):
        #continue
      #if homingTarget.is_in_group('player'):
        #continue
      #if closestTarget and global_position.distance_to(homingTarget.global_position) < global_position.distance_to(closestTarget.global_position):
        #closestTarget = homingTarget
      #else:
        #closestTarget = homingTarget
    #_home_on_closest_target(closestTarget)
  #elif _homing_targets.size() == 1: # It's just the player
    #_home_on_player(_homing_targets[0])
  #var closestTarget = _get_closest_target_to_player()
  if Global.object_exists(_lockedTarget) and _lockedTarget.is_in_group('player'):
    _home_on_player(_lockedTarget)
  elif Global.object_exists(_lockedTarget):
    _home_on_closest_target(_lockedTarget)
  else: # We have no targets, fall back.
    printerr('DBG: Homing throwable object has no targets, killing it.')
    _hit(null)
    
  
func _move_to_target() -> void:
  if not Global.object_exists(_lockedTarget):
    return
  var direction_to = global_position.direction_to(_lockedTarget.global_position)
  velocity += direction_to * homing_speed


func aim_release() -> void:
  super()
  _homingTimer.start(homing_delay)
