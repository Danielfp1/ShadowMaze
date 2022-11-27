extends Area2D
var entrou = false

func _ready():
	$Texto.visible = false
	$OpeningNote.visible = false
	$Pressione.visible = false
	$ClosedNote.visible = true

func _physics_process(delta):
	if entrou:
		if Input.is_action_just_pressed("action"): 
			$ClosedNote.visible = false
			$OpeningNote.visible = true
			$OpeningNote.play()
	pass


func _on_MessageBox_body_exited(body):
	
	if body.name == "Player":
		entrou = false
		$Texto.visible = false
		$Pressione.visible = false
		$ClosedNote.visible = true
		$OpeningNote.visible = false
		$OpeningNote.frame = 0
	pass # Replace with function body.


func _on_MessageBox_body_entered(body):
	print(body.name)
	if body.name == "Player":
		entrou = true
		$Pressione.visible = true
	pass # Replace with function body.




func _on_OpeningNote_animation_finished():
	$Texto.visible = true
	$OpeningNote.stop()
	

func _on_OpeningNote_frame_changed():
	print("mudando")
