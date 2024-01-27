extends ThrowableObject


func _draw() -> void:
  super()
  draw_circle($Graphics.position, $WorldCollider.shape.radius, Color(1, 0, 0))
