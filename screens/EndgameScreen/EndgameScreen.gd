extends Screen


# Called when the node enters the scene tree for the first time.
func _ready():
  $SFX/WopWop.play()
  await get_tree().create_timer(2.0).timeout
  var tween = create_tween()
  tween.tween_property($SFX/WopWop, 'pitch_scale', 0.25, 2.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
