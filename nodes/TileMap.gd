extends TileMap

@onready var tilemap = %TileMap
# Called when the node enters the scene tree for the first time.
func _ready():
# Get size of tilemap
	print(get_used_rect().size)
	var list = get_top_level_nodes()
	var impassibleList = []
	for n in list:
		impassibleList.append(get_current_tile(n.position))
	
	print(impassibleList)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getObjectLocations():
		var nodes = get_top_level_nodes()
		var list = []
		for n in nodes:
			list.append(get_current_tile(n.position))
		print(list)
		return list

func get_top_level_nodes() -> Array:
	var root = get_tree().get_current_scene()
	return root.get_children()

func get_all_nodes() -> Array:
	var root = get_tree().get_current_scene()
	var nodes = []
	get_nodes_recursive(root, nodes)
	return nodes

func get_nodes_recursive(node: Node, nodes: Array) -> void:
	nodes.append(node)
	for child in node.get_children():
		get_nodes_recursive(child, nodes)
		
func get_current_tile(world_position) -> Vector2i:
	return tilemap.local_to_map(tilemap.to_local(world_position))
