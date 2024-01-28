class_name Screen
extends Node

signal made_active
signal made_inactive
@onready var player_hearts = $UI/player_hearts
@onready var progress_bar = $UI/progress_bar
@onready var player = $player
var heart_texture  = load("res://sprites/player/heart.png")

func _ready():
  await get_tree().root.ready
  var heart = TextureRect.new();
  heart.texture = heart_texture;
  player_hearts.add_child(heart)

func _process(delta):
    if progress_bar != null:
       progress_bar.value = 100*( player.position.x / (9600*3))




func _on_player_health_changed(gained):
    if gained:
        var heart = TextureRect.new();
        heart.texture = heart_texture;
        player_hearts.add_child(heart)
    else:
        if player_hearts.get_children().size() > 0:
            player_hearts.remove_child(player_hearts.get_children()[0])
    pass # Replace with function body.
