extends Path2D


@export var currentThrowable : PackedScene :
  set = _set_currentThrowable

@onready var _animatorNode = $Animator
@onready var _throwerBasket = $ThrowSource/Basket


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


func _unhandled_input(_inputEvent: InputEvent) -> void:
  if Input.is_action_pressed("fire"):
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _set_currentThrowable(value: PackedScene) -> void:
  if not value:
    currentThrowable = null
    return
  
  var testInstance = value.instance()
  if not testInstance is ThrowableObject:
    currentThrowable =  null
    return
    
  currentThrowable = value
