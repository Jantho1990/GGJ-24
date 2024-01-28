extends Control

@onready var _resumeButton = $Margin/VBox/HBox/Okay
# Called when the node enters the scene tree for the first time.
func _ready():
    _resumeButton.pressed.connect(_on_ResumeButton_pressed)
    hide()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_ResumeButton_pressed() -> void:
  resume_game()
  hide()

func pause_game() -> void:
  get_tree().paused = true


func resume_game() -> void:
  get_tree().paused = false


