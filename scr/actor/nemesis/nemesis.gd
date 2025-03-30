extends CharacterBody2D

enum {
	WAIT, #out of map but not get back yet
	READY, #staring at player
	CHARGE, #charging
	REC #get back to map border
}

var state = WAIT

var wait_time = 0
var ready_time = 0

var target = null

var wait_t_range = Vector2(1,3)
var ready_t_range = Vector2(1,2)

var charge_dir = Vector2.ZERO

const INIT_SPD = 30
const ACC_RATE = 1.06
var spd = 0

var charge_base_pos = Vector2.ZERO
var charge_go_pos = Vector2.ZERO

func _ready() -> void:
	var ran_rad = randf_range(0, PI * 2)
	ran_pos()
	#global_position = Vector2(480/2, 320/2) + Vector2(cos(ran_rad) * 300, -sin(ran_rad) * 300)
	#
	#wait_time = randf_range(wait_t_range.x, wait_t_range.y)

func _physics_process(delta: float) -> void:
	match state:
		WAIT:
			wait_time -= delta
			
			if wait_time <= 0:
				ran_pos()
				state = REC
		READY:
			$Line2D.visible = true
			ready_time -= delta
			
			if ready_time <= 0:
				charge_dir = global_position.direction_to(%Rabbit.global_position)
				spd = INIT_SPD
				
				state = CHARGE
			
			$Line2D.set_point_position(0, Vector2.ZERO)
			$Line2D.set_point_position(1, to_local(%Rabbit.global_position) * 100)
			
			$Line2D.default_color = Color("540a0a")
		CHARGE:
			velocity = charge_dir * spd
			spd = spd * ACC_RATE
			
			if global_position.distance_to(Vector2(480/2,320/2)) > 300:
				wait_time = randf_range(wait_t_range.x, wait_t_range.y)
				
				state = WAIT
			
			for ene in $ene_hurt_area.get_overlapping_bodies():
				ene.queue_free()
			
			move_and_slide()
			$Line2D.default_color = Color("c27800")
		REC:
			$Line2D.visible = false
			velocity = (global_position.direction_to(target.global_position) * global_position.distance_to(target.global_position) * 0.03) / delta
			
			if velocity.length() < 5:
				ready_time = randf_range(ready_t_range.x, ready_t_range.y)
				
				state = READY
			
			move_and_slide()

func _process(delta: float) -> void:
	match state:
		WAIT:
			pass
		READY:
			pass
		CHARGE:
			pass
		REC:
			pass

func shortest_pos():
	for pos in get_tree().get_nodes_in_group("neme_pos"):
		if target == null or global_position.distance_to(pos.global_position) < global_position.distance_to(target.global_position):
			target = pos

func ran_pos():
	randomize()
	target = get_tree().get_nodes_in_group("neme_pos").pick_random()
	
	var center_point = Vector2(480/2,320/2)
	
	global_position = center_point + center_point.direction_to(target.global_position) * 300
