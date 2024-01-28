extends Control


@onready var _resumeButton = $Margin/VBox/HBox/Resume
@onready var _titleScreenButton = $Margin/VBox/HBox/TitleScreen


# Called when the node enters the scene tree for the first time.
func _ready():
  _resumeButton.pressed.connect(_on_ResumeButton_pressed)
  _titleScreenButton.pressed.connect(_on_TitleScreenButton_pressed)
  hide()


func _unhandled_input(_inputEvent: InputEvent) -> void:
  if Input.is_action_just_pressed("pause"):
    show()
    pause_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _on_ResumeButton_pressed() -> void:
  resume_game()
  hide()


func _on_TitleScreenButton_pressed() -> void:
  resume_game()
  hide()
  ScreenManager.change_screen('TitleScreen')


func pause_game() -> void:
  get_tree().paused = true


func resume_game() -> void:
  get_tree().paused = false
