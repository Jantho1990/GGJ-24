extends Node2D

var heart_texture  = load("res://sprites/player/heart.png")
@onready var player_hearts = $UI/player_hearts
@onready var progress_bar = $UI/progress_bar
@onready var player = $player
# Called when the node enters the scene tree for the first time.
func _ready():
  var heart = TextureRect.new();
  heart.texture = heart_texture;
  player_hearts.add_child(heart)
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  progress_bar.value = 100*( player.position.x / 9600)
  pass


func _on_player_health_changed(gained):
    if gained:
        var heart = TextureRect.new();
        heart.texture = heart_texture;
        player_hearts.add_child(heart)
    else:
        if player_hearts.get_children().size() > 0:
            player_hearts.remove_child(player_hearts.get_children()[0])
    pass # Replace with function body.
