@tool
extends Node3D

enum SOUND_COLOR { NONE, BLUE, GREEN, RED, YELLOW }
var _selected_color: SOUND_COLOR = SOUND_COLOR.NONE

@export
var SelectedColor: SOUND_COLOR:
	get:
		return _selected_color
	set(value):
		_selected_color = value
		if is_inside_tree():
			_apply_color_and_sound()

@export var mesh_node: MeshInstance3D
@onready var audio_player: AudioStreamPlayer3D = _get_or_create_audio()
var material: StandardMaterial3D
static var _audio_streams: Dictionary = {}

func _ready() -> void:
	if mesh_node is MeshInstance3D:
		_define_material()
	else:
		push_error("SoundColorManager: mesh_node is not a MeshInstance3D: %s" % [mesh_node])
		material = null
	_apply_color_and_sound()

func _define_material() -> void:
	if mesh_node == null:
		return
	mesh_node.material_override = null
	var mesh = mesh_node.mesh
	if mesh:
		for i in mesh.get_surface_count():
			mesh_node.set_surface_override_material(i, null)
	var active_mat = null
	if mesh_node.has_method("get_active_material"):
		active_mat = mesh_node.get_active_material(0)
	elif mesh:
		active_mat = mesh.surface_get_material(0)
	if active_mat:
		material = active_mat.duplicate()
	else:
		material = StandardMaterial3D.new()
	mesh_node.material_override = material

func _apply_color_and_sound() -> void:
	_update_material_color()
	_play_sound_for_color()

func _update_material_color() -> void:
	_define_material()
	if material == null:
		return
	var color: Color
	match _selected_color:
		SOUND_COLOR.NONE:
			color = Color(0.5, 0.5, 0.5)
		SOUND_COLOR.BLUE:
			color = Color(0, 0, 1, 1)
		SOUND_COLOR.GREEN:
			color = Color(0, 1, 0, 1)
		SOUND_COLOR.RED:
			color = Color(1, 0, 0, 1)
		SOUND_COLOR.YELLOW:
			color = Color(1, 1, 0, 1)
		_:
			color = Color(0.2, 0.2, 0.2)
	material.albedo_color = color

func _play_sound_for_color() -> void:
	if audio_player == null:
		return
	var stream = _get_stream_for_color()
	if audio_player.stream != stream:
		audio_player.stream = stream
		if !Engine.is_editor_hint() and stream:
			audio_player.play()
		elif _selected_color == SOUND_COLOR.NONE and audio_player.playing:
			audio_player.stop()

func _get_stream_for_color() -> AudioStream:
	_load_audio_streams_once()
	match _selected_color:
		SOUND_COLOR.BLUE:
			return _audio_streams.get("BLUE")
		SOUND_COLOR.GREEN:
			return _audio_streams.get("GREEN")
		SOUND_COLOR.RED:
			return _audio_streams.get("RED")
		SOUND_COLOR.YELLOW:
			return _audio_streams.get("YELLOW")
		_:
			return null

func _load_audio_streams_once() -> void:
	if _audio_streams.size() > 0:
		return
	_audio_streams["BLUE"] = preload("res://addons/synesthetic_sound_color/assets/audio/la_azul.ogg")
	_audio_streams["GREEN"] = preload("res://addons/synesthetic_sound_color/assets/audio/do_verde.ogg")
	_audio_streams["RED"] = preload("res://addons/synesthetic_sound_color/assets/audio/fa_vermelho.ogg")
	_audio_streams["YELLOW"] = preload("res://addons/synesthetic_sound_color/assets/audio/re_amarelo.ogg")

func _get_or_create_audio() -> AudioStreamPlayer3D:
	for child in get_children():
		if child is AudioStreamPlayer3D:
			return child
	var audio = AudioStreamPlayer3D.new()
	audio.name = "Audio"
	add_child(audio)
	return audio
