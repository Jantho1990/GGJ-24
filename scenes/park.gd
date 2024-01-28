extends Node2D

var heart_texture  = load("res://sprites/player/heart.png")
@onready var player_hearts = $UI/player_hearts
# Called when the node enters the scene tree for the first time.
func _ready():
  var heart = TextureRect.new();
  heart.texture = heart_texture;
  player_hearts.add_child(heart)
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _on_player_health_changed(gained):
    if gained:
        var heart = TextureRect.new();
        heart.texture = heart_texture;
        player_hearts.add_child(heart)
    pass # Replace with function body.
