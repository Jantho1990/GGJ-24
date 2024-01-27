extends Node2D


const TestThrowableObject = preload("res://game_objects/TestBallThrowableObject/TestBallThrowableObject.tscn")


func _input(_inputEvent: InputEvent) -> void:
  if Input.is_action_just_pressed("test_throw"):
    print('DBG: throw!')
    _spawn_throwable_object(TestThrowableObject.instantiate())


func _spawn_throwable_object(throwableObject: ThrowableObject) -> void:
  throwableObject.global_position = get_global_mouse_position()
  add_child(throwableObject)
