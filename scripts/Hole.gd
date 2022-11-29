extends Area2D
var entrou = false
var player_ref = null

func _physics_process(delta):
	if entrou:
		body.fall()

func _on_Hole_body_entered(body):
	if body.name == "Player":
		entrou = true
		player_ref = body
