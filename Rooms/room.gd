extends TileMap
class_name Room

@export var left_available : bool = false
@export var right_available : bool = false
@export var up_available : bool = false
@export var down_available : bool = false

const DIRECTION_MARKER_LAYER : int = 1
const atlas_coord_2_direction : Dictionary = {
	Vector2i(0,3): "left",
	Vector2i(1,3): "right",
	Vector2i(0,4): "up",
	Vector2i(1,4): "down",
	Vector2i(0,2): "bush",
}

func initialise_available():
	for coords in get_used_cells(DIRECTION_MARKER_LAYER):
		var atlas_coords : Vector2i = get_cell_atlas_coords(DIRECTION_MARKER_LAYER, coords)
		var curr_direction : String = atlas_coord_2_direction[atlas_coords]
		if curr_direction == "left":
			left_available = true
		if curr_direction == "right":
			right_available = true
		if curr_direction == "up":
			up_available = true
		if curr_direction == "down":
			down_available = true

func _ready() -> void:
	initialise_available()

func get_available_branches() -> Array:
	var available_branches : Array = []
	if left_available:
		available_branches.append("left")
	if right_available:
		available_branches.append("right")
	if up_available:
		available_branches.append("up")
	if down_available:
		available_branches.append("down")
	return available_branches


