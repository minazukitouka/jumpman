extends Camera2D

export(NodePath) var character_node
var character
var window_height

func _ready():
	character = get_node(character_node)
	window_height = ProjectSettings.get_setting('display/window/size/height')

func _process(delta):
	var room_position = floor(character.position.y / window_height)
	position.y = room_position * window_height
