extends Node2D


const TestThrowableObject = preload("res://game_objects/TestBallThrowableObject/TestBallThrowableObject.tscn")

var testObject


func _input(_inputEvent: InputEvent) -> void:
  if Input.is_action_just_released("test_throw"):
    print('DBG: throw!')
    testObject.aim_release()
    testObject.global_position = get_global_mouse_position()
    testObject = null
  elif Input.is_action_pressed('test_throw'):
    if not testObject:
      testObject = TestThrowableObject.instantiate()
    add_child(testObject)
    testObject.global_position = get_global_mouse_position()
    testObject.aim()
    


func _spawn_throwable_object(throwableObject: ThrowableObject) -> void:
  throwableObject.global_position = get_global_mouse_position()
  add_child(throwableObject)
