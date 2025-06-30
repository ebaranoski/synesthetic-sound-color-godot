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

var material: StandardMaterial3D
@export var mesh_node: MeshInstance3D
@onready var audio_player: AudioStreamPlayer3D = _get_or_create_audio()
static var _audio_streams: Dictionary = {}

func _ready() -> void:
	if mesh_node is MeshInstance3D:
		# não usa material_override aqui
		_define_material()
	else:
		push_error("SoundColorManager: mesh_node is not a MeshInstance3D: %s" % [mesh_node])
	_apply_color_and_sound()

func _define_material() -> void:
	# apenas garante que mesh_node e material base existam, sem override
	if mesh_node == null:
		return
	var mesh = mesh_node.mesh
	if mesh and mesh.get_surface_count() > 0:
		var orig = mesh.surface_get_material(0)
		if orig and orig is StandardMaterial3D:
			material = orig.duplicate()
		else:
			material = StandardMaterial3D.new()
	else:
		material = StandardMaterial3D.new()

func _apply_color_and_sound() -> void:
	_update_material_color()
	_play_sound_for_color()

func _update_material_color() -> void:
	if mesh_node == null:
		return
	var mesh = mesh_node.mesh
	if not mesh:
		return

	# sempre duplica o mesh para manter instâncias independentes
	mesh = mesh.duplicate()
	mesh_node.mesh = mesh

	# determina a cor (mantido exatamente como funcionava)
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

	# aplica uma cópia do material em cada surface, preservando texturas
	for i in range(mesh.get_surface_count()):
		var orig = mesh.surface_get_material(i)
		var new_mat: StandardMaterial3D

		if orig and orig is StandardMaterial3D:
			new_mat = orig.duplicate()
		elif orig:
			new_mat = StandardMaterial3D.new()
			if orig.has_property("albedo_texture"):
				new_mat.albedo_texture = orig.albedo_texture
		else:
			new_mat = StandardMaterial3D.new()

		# ajusta o albedo_color, que funciona corretamente
		new_mat.albedo_color = color
		mesh.surface_set_material(i, new_mat)

func _play_sound_for_color() -> void:
	audio_player = _get_or_create_audio()
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
			return _audio_streams["BLUE"]
		SOUND_COLOR.GREEN:
			return _audio_streams["GREEN"]
		SOUND_COLOR.RED:
			return _audio_streams["RED"]
		SOUND_COLOR.YELLOW:
			return _audio_streams["YELLOW"]
		_:
			return null

func _load_audio_streams_once() -> void:
	if _audio_streams.size() > 0:
		return
	_audio_streams["BLUE"]   = preload("res://addons/synesthetic_sound_color/assets/audio/la_azul.ogg")
	_audio_streams["GREEN"]  = preload("res://addons/synesthetic_sound_color/assets/audio/do_verde.ogg")
	_audio_streams["RED"]    = preload("res://addons/synesthetic_sound_color/assets/audio/fa_vermelho.ogg")
	_audio_streams["YELLOW"] = preload("res://addons/synesthetic_sound_color/assets/audio/re_amarelo.ogg")

func _get_or_create_audio() -> AudioStreamPlayer3D:
	for child in get_children():
		if child is AudioStreamPlayer3D:
			child.autoplay = true
			return child
	var audio = AudioStreamPlayer3D.new()
	audio.name = "Audio"
	add_child(audio)
	audio.autoplay = true
	return audio
