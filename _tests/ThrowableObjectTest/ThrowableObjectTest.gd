extends Node2D


#const TestThrowableObject = preload("res://game_objects/throwables/TestBallThrowableObject/TestBallThrowableObject.tscn")
const TestThrowableObject = preload("res://game_objects/throwables/TennisBallThrowableObject/TennisBallThrowableObject.tscn")

var testObject


func _ready() -> void:
  var test_vec1 = Vector2(100, 0)
  var test_vec2 = Vector2(0, 0)
  #print('DBG: vec1 to vec2 %s' % [test_vec1.move_toward(test_vec2, 0.01667)])


func _input(_inputEvent: InputEvent) -> void:
  if Input.is_action_just_released("test_throw"):
    if not testObject:
      return
    #print('DBG: throw!')
    testObject.aim_release()
    testObject.global_position = get_global_mouse_position()
    testObject = null
  elif Input.is_action_pressed('test_throw'):
    if not testObject:
      testObject = TestThrowableObject.instantiate()
      add_child(testObject)
      testObject.aim()
    testObject.global_position = get_global_mouse_position()
    


func _spawn_throwable_object(throwableObject: ThrowableObject) -> void:
  throwableObject.global_position = get_global_mouse_position()
  add_child(throwableObject)
