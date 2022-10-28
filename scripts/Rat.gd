extends KinematicBody2D

var player_ref = null
var velocity: Vector2

export (int) var speed

func _physics_process(_delta: float) -> void:
	if player_ref != null:
		pass


func on_body_entered(body):
	pass 


func on_body_exited(_body):
	player_ref = null
