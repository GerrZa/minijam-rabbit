extends CharacterBody2D

enum {
	IDLE, #First start
	JUMP,
	WAIT
}

var state = IDLE

const DEF_JUMP_SPD = 700
var jump_spd = 0

var jump_dir = Vector2.ZERO

var to_mouse_rad = 0

const DEF_JUMP_CD = 0.2
var jump_cd = DEF_JUMP_CD
const JUMP_LERP = 0.8

const DEF_INVIN = 4
var invin = 0

var hp = 3

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	to_mouse_rad = atan2((get_global_mouse_position() - global_position).y, (get_global_mouse_position() - global_position).x)
	
	if invin > 0:
		invin -= delta
	
	match state:
		IDLE:
			if Input.is_action_just_pressed("m1"):
				jump_dir = global_position.direction_to(get_global_mouse_position())
				state = JUMP
				jump_spd = DEF_JUMP_SPD
			
		JUMP:
			velocity = jump_dir * jump_spd
			jump_spd = jump_spd * JUMP_LERP
			
			if jump_spd < 1:
				jump_cd = DEF_JUMP_CD
				state = WAIT
			
			if velocity.x < 0:
				$sprite.flip_h = true
			else:
				$sprite.flip_h = false
			
			move_and_slide()
		WAIT:
			jump_cd -= delta
			
			if jump_cd <= 0:
				jump_spd = DEF_JUMP_SPD
				jump_dir = global_position.direction_to(get_global_mouse_position())
				state = JUMP

func _process(delta: float) -> void:
	$arrow.look_at(get_global_mouse_position())
	
	match state:
		IDLE:
			$sprite.offset = Vector2(-5,-9)
		JUMP:
			$sprite.offset.x = -5
			$sprite.offset.y = -9 - (sin(jump_spd/DEF_JUMP_SPD) * 4)
		WAIT:
			$sprite.offset = Vector2(-5,-9)

func hurt():
	invin = DEF_INVIN
	
	if hp > 0:
		hp -= 1
	else:
		queue_free()
