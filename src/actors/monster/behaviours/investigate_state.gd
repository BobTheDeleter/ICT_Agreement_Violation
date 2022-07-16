class_name InvestigateState
extends "res://src/_base_state.gd"


func _init(csf, e, rs, ss, p, ert, drm, drr, pd).(csf, e):
	run_speed = rs
	space_state = ss
	player = p
	emotion_recognition_times = ert
	distance_recognition_multipliers = drm
	distance_recognition_ranges = drr
	point_distance = pd

	e.add_child(attack_timer)
	attack_timer.connect("timeout", self, "_on_attack_timeout")

func _on_enter():
	start_attack_timer()
	player_last = entity.player.node.position

func start_attack_timer():
	var emotion_time = emotion_recognition_times[entity.emotion]
	var distance_mult = 1
	for i in distance_recognition_ranges.size():
		if entity.position.distance_to(entity.player.node.position) < distance_recognition_ranges[i]:
			distance_mult = distance_recognition_multipliers[i]
	
	attack_timer.start(emotion_time*distance_mult)

func _on_exit():
	entity.emotion = min(entity.emotion+1, entity.emotion_recognition_times.size()-1)

var emotion_recognition_times
var distance_recognition_multipliers
var distance_recognition_ranges
var attack_timer = Timer.new()
var player_last = Vector2.ZERO
func update(_delta):
	var pos = player_los_check()
	if pos is Vector2:
		player_last = pos
		if attack_timer.is_stopped():
			start_attack_timer()
	else:
		attack_timer.stop()

var run_speed
var point_distance
func physics_update(delta):
	entity.position += entity.position.direction_to(player_last)*run_speed*delta
	entity.move_and_slide(Vector2.ZERO)
	  
	if entity.position.distance_to(player_last) < point_distance:
		#change_state_func.call_func("wander")
		#TODO Attack state
		print("reach last known position")
	
var space_state
var player_coll_layer
var player
func player_los_check():
	var result = space_state.intersect_ray(entity.global_position, player.node.global_position, [self])
	if result:
		if result.collider == player.node:
			return result.position
		entity.vdebug.points = [result.position, entity.position]
		
	return false

func _on_attack_timeout():
	#change_state_func.call_func("wander")
	#TODO same here
	print("time to die")
