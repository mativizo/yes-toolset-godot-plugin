@tool
extends Node3D

@export var grid_size = 0.1
@export var bold_line_interval = 0.5

func _ready():
	var total_size = Vector2(100, 100)  # Adjust as needed
	var bold_line_size = bold_line_interval / grid_size

	for x in range(int(total_size.x / grid_size) + 1):
		var line = Line2D.new()
		line.set_default_color(Color.RED)
		line.width = 30 #x % 20 if bold_line_size == 0 else 10
		line.add_point(Vector2(x * grid_size, 0))
		line.add_point(Vector2(x * grid_size, total_size.y))
		add_child(line)

	for y in range(int(total_size.y / grid_size) + 1):
		var line = Line2D.new()
		line.set_default_color(Color.RED)
		line.width = y % 20 if bold_line_size == 0 else 10
		line.add_point(Vector2(0, y * grid_size))
		line.add_point(Vector2(total_size.x, y * grid_size))
		add_child(line)
