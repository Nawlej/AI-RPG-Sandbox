extends CharacterBody2D

## Base character class that provides common functionality for all NPCs in the game.
## This class handles basic character interactions, proximity detection, and state management.
## @author AI-RPG-Sandbox
## @notice This is a base class that should be extended by specific character types

@onready var state_machine = $StateMachine
@onready var dialogue = $DialogueComponent
@onready var ai = $AIComponent

var nearby_objects: Array[Node] = []

## Initializes the character and sets up necessary connections
## @dev Called automatically when the character is added to the scene
func _ready():
	add_to_group("npc")
	$ProximitySensor.body_entered.connect(_on_body_entered)
	$ProximitySensor.body_exited.connect(_on_body_exited)

## Makes the character speak the given text
## @param text The message to be spoken
## @dev Currently just prints to console, can be extended for actual speech
func speak(text: String):
	print(name + " says: " + text)
	
## Handles when another character speaks to this character
## @param speaker The character who is speaking
## @param message The message being spoken
## @dev Currently just prints to console, can be extended for actual dialogue handling
func _on_spoken_to(speaker: CharacterBody2D, message: String):
	print(name + " heard " + speaker.name + " say", message)
	
## Called when another body enters the proximity sensor area
## @param body The body that entered the area
## @dev Only processes NPCs that are in the "npc" group
func _on_body_entered(body):
	nearby_objects.append(body)
	if body.is_in_group("npc"):
		print(body.name + " entered interaction range")
	
## Called when another body exits the proximity sensor area
## @param body The body that exited the area
## @dev Only processes NPCs that are in the "npc" group
func _on_body_exited(body):
	nearby_objects.erase(body)
	if body.is_in_group("npc"):
		print(body.name + " left interaction range")
	
## Gets all objects within a specified radius of a given point
## @param origin The center point to search from
## @param radius The radius to search within
## @param collision_mask The collision mask to filter objects (default: 1)
## @return Array of objects found within the radius
## @dev Uses physics queries to find objects efficiently
func get_nearby_objects(origin: Vector2, radius: float, collision_mask: int = 1) -> Array:
	var space = get_world_2d().direct_space_state

	var shape := CircleShape2D.new()
	shape.radius = radius

	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0, origin)
	query.collision_mask = collision_mask # set to match your NPCs/items

	return space.intersect_shape(query, 64)
