extends ThrowableObject


func _draw() -> void:
  draw_circle($Graphics.position, $WorldCollider.shape.radius, Color(1, 0, 0))
