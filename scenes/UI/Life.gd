extends Control

var heart_size: float = 62.5

func on_player_life_changed(player_hearts: float) ->  void:
	$Hearts.rect_size.x = player_hearts * heart_size
