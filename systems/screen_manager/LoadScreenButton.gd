class_name LoadScreenButton
extends Button


@export var screen_name : String


# Called when the node enters the scene tree for the first time.
func _ready():
  pressed.connect(_on_Pressed)


func _on_Pressed() -> void:
  ScreenManager.change_screen(screen_name)
