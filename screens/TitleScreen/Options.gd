extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
  pressed.connect(_on_Pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _on_Pressed() -> void:
  $FallbackOptions.show()
