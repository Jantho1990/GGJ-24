extends StaticBody2D

const y_position = 2
# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func explode():
  $shape.disabled = true;
  $sprite.play('explode');
  $SFX/Boom.play()


func _on_sprite_animation_finished():
  if $sprite.animation == 'explode':
    queue_free();
  pass # Replace with function body.
