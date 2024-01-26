@tool
extends EditorPlugin

var plugin
var yes_grid_script

func _enter_tree():
	plugin = preload("res://addons/yes-toolset-plugin/plugin_script.gd").new()
	add_inspector_plugin(plugin)
	
	yes_grid_script = preload("res://addons/yes-toolset-plugin/yes_grid.gd")
	add_custom_type("YesGrid", "Node3D", yes_grid_script, preload("res://icon.svg"))

func _exit_tree():
	remove_inspector_plugin(plugin)
	remove_custom_type("YesGrid")

