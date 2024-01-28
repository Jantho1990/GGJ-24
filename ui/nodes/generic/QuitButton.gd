class_name QuitButton
extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
  pressed.connect(func(): get_tree().quit())

