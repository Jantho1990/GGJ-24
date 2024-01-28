extends Node


@export var default_screen : String


func _ready() -> void:
  await get_tree().root.ready
  
  ScreenManager.change_screen(default_screen)
