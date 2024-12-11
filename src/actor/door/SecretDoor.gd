extends Node2D

export var door_path : NodePath
onready var door_node = get_node_or_null(door_path)

export var map_to_visit := ""
var is_visited := false

func _ready():
	is_visited = Shared.maps_visited.has(map_to_visit)
	
	print("looking for ", map_to_visit, " in ", Shared.maps_visited, " ", is_visited, " ", door_node)
	
	if !is_visited and is_instance_valid(door_node):
		print("ok")
		door_node.visible = false
		if is_instance_valid(door_node.arrow):
			print("huh")
			door_node.arrow.is_locked = true
