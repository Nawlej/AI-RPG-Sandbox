extends AnimatedSprite2D

@export var tile_size: int = 16  # Size of each tile in pixels
@onready var object = $"."

func _ready():
	get_Image_Size()
		
func get_Image_Size():
		if sprite_frames:
		var anim = animation  # Current animation
		var frame = object.frame     # Current frame
		var tex = sprite_frames.get_frame_texture(anim, frame)
		
		if tex:
			var image_size = tex.get_size() * scale
			var tiles_x = ceil(image_size.x / tile_size)
			var tiles_y = ceil(image_size.y / tile_size)
			var total_tiles = tiles_x * tiles_y

			print("Covers ", tiles_x, " x ", tiles_y, " tiles (", total_tiles, " total)")
		else:
			print("No texture found for frame.")
	else:
		print("No SpriteFrames resource assigned.")

func get_covered_tiles(sprite: Node2D, tilemap: TileMap) -> Array:
	var covered_tiles := []

	var tile_size = tilemap.tile_set.tile_size  # Vector2i
	var half_size = (sprite.get_rect().size * sprite.scale) / 2.0

	# Get the top-left and bottom-right corners in local space
	var top_left = sprite.global_position - half_size
	var bottom_right = sprite.global_position + half_size

	# Convert world positions to tile coordinates
	var top_left_tile = tilemap.local_to_map(tilemap.to_local(top_left))
	var bottom_right_tile = tilemap.local_to_map(tilemap.to_local(bottom_right))

	# Loop over tiles within bounds
	for x in range(top_left_tile.x, bottom_right_tile.x):  # Corrected loop
		for y in range(top_left_tile.y, bottom_right_tile.y):  # Corrected loop
			covered_tiles.append(Vector2i(x, y))

	return covered_tiles
