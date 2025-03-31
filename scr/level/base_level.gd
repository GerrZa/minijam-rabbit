extends Node2D

var spawn_t_range = Vector2(2,5)
var spawn_n_range = Vector2(4,7)

var time = 0

var ene = preload("res://scr/actor/enemy/normal_eneme.tscn")

func _ready() -> void:
	$ene_spawn_timer.start(1.5)

func _physics_process(delta: float) -> void:
	time += delta

func _on_timer_timeout() -> void:
	for i in range(randi_range(spawn_n_range.x, spawn_n_range.y)):
		spawn_ene()
		
		await get_tree().create_timer(0.25).timeout
	
	randomize()
	$ene_spawn_timer.start(randf_range(spawn_t_range.x, spawn_t_range.y))

func spawn_ene():
	var ene_ins = ene.instantiate()
	var pos = get_tree().get_nodes_in_group("norm_pos").pick_random()
	
	ene_ins.global_position = pos.global_position
	
	get_tree().current_scene.add_child(ene_ins)
