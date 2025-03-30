extends CharacterBody2D

var center_point = Vector2(480/2, 320/2)

var spd = 400

func _ready() -> void:
	#var ran_rad = randf_range(0, PI * 2)
	pass
	#global_position = center_point + (Vector2(cos(ran_rad), -sin(ran_rad)) * 300)

func _physics_process(delta: float) -> void:
	
	if get_tree().current_scene.get_node("Rabbit") != null:
		var to_player = global_position.direction_to(get_tree().current_scene.get_node("Rabbit").global_position)
		
		if to_player.x < 0:
			$Icon.flip_h = true
		else:
			$Icon.flip_h = false
		
		global_position += to_player * 20 * delta
		
		for ene in $ene_check.get_overlapping_bodies():
			global_position += -global_position.direction_to(ene.global_position) * (14 - global_position.distance_to(ene.global_position)) * 0.1
