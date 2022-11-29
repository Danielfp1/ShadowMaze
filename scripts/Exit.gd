extends Area2D
var entrou = false

func _ready():
	$Pressione.visible = false

func _physics_process(delta):
	if entrou:
		if Input.is_action_just_pressed("action"): 
			get_tree().change_scene("res://scenes/Maps/Credits.tscn")

func _on_Exit_body_entered(body):
	if body.name == "Player":
		entrou = true
		$Pressione.visible = true


func _on_Exit_body_exited(body):
	if body.name == "Player":
		entrou = false
		$Pressione.visible = false
