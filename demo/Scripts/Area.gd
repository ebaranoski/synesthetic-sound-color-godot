extends Area3D
@onready var emissor = get_child(1).get_child(1)

func _ready():
	emissor.stop()

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		emissor.play()

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		emissor.stop()
