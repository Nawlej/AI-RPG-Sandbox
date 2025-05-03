extends "res://nodes/characters/base/BaseCharacter.gd"

## Reference to the text input UI element
@onready var text_input = $TextInput

## Called every physics frame
## @param delta Time elapsed since last physics frame
func _physics_process(delta):
	handle_input(delta)

## Handles all player input including movement and text input
## @param delta Time elapsed since last physics frame
func handle_input(delta):
	# Handle movement input
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	velocity = input_vector.normalized() * 400
	move_and_slide()
	
	# Handle text input
	if Input.is_action_just_pressed("ui_accept"): # ENTER key
		open_text_input()

## Opens the text input UI and connects its signal
## @dev Shows the text input UI and connects the text_submitted signal
func open_text_input():
	if text_input:
		text_input.show()
		text_input.text_submitted.connect(_on_text_submitted)
		text_input.grab_focus()

## Handles the submitted text from the input UI
## @param text The text that was submitted
## @dev Currently just prints the text, can be extended for actual command processing
func _on_text_submitted(text: String):
	print("Player entered: ", text)
	if text_input:
		text_input.hide()
		text_input.text_submitted.disconnect(_on_text_submitted)
