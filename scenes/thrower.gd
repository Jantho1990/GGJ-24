extends Path2D


@export var currentThrowable : PackedScene :
  set = _set_currentThrowable

var _activeThrowable : ThrowableObject

@onready var _animatorNode = $Animator
@onready var _throwerBasket = $ThrowSource/Basket


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


func _unhandled_input(_inputEvent: InputEvent) -> void:
  if not currentThrowable:
    return
  
  if Input.is_action_pressed("fire"):
    if not _activeThrowable:
      _activeThrowable = currentThrowable.instantiate()
      _activeThrowable.aim()  
      _throwerBasket.add_child(_activeThrowable)
      _animatorNode.play("move")
  elif Input.is_action_just_released("fire"):
    _activeThrowable.aim_release()
    _throwerBasket.remove_child(_activeThrowable)
    var launchSource = get_parent()
    launchSource.get_parent().call_deferred("add_child", _activeThrowable)
    _activeThrowable.global_position = _throwerBasket.global_position
    _animatorNode.stop()
    #await get_tree().idle_frame
    #await get_tree().idle_frame
    await _activeThrowable.tree_entered
    _activeThrowable = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _set_currentThrowable(value: PackedScene) -> void:
  if not value:
    currentThrowable = null
    return
  
  var testInstance = value.instantiate()
  if not testInstance is ThrowableObject:
    currentThrowable =  null
    return
    
  currentThrowable = value
