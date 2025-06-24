# synesthetic_sound_color_plugin.gd
@tool
extends EditorPlugin

func _enter_tree():
	var script = preload("res://addons/synesthetic_sound_color/scripts/sound_color_manager.gd")
	add_custom_type("SoundColor3D", "Node3D", script, preload("res://addons/synesthetic_sound_color/assets/icons/SoundColor3D.png"))
func _exit_tree():
	remove_custom_type("SoundColor3D")
