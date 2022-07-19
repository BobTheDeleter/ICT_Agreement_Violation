class_name InvestigateState
extends "./_base_state.gd"

func _init(e, ss, ert, drm, drr, ar).(e):
	speed = ss
	emotion_recognition_times = ert
	distance_recognition_multipliers = drm
	distance_recognition_ranges = drr
	attack_radius = ar

	e.add_child(attack_timer)
	attack_timer.one_shot = true

func on_enter():
	player_last = entity.player_last_known
	entity.current_path = entity.pathfind(entity.position, player_last)
	start_attack_timer()

func on_exit():
	entity.player_last_known = player_last
	attack_timer.stop()

var emotion_recognition_times
var distance_recognition_multipliers
var distance_recognition_ranges
var attack_timer = Timer.new()
var player_last = Vector2.ZERO
var attack_radius
func update(_delta):    
	if entity.can_see_player():
		player_last = entity.player.position
		if entity.position.distance_to(entity.player.position) < attack_radius:
			entity.change_state("chase")
		
		if attack_timer.is_stopped():
			entity.change_state("chase")
	else:
		entity.change_state("search")
	# if entity.position.distance_to(player_last) < wp_radius:
	#     entity.change_state("search")

func pathfind():
	pass

func start_attack_timer():
	var emotion_time = emotion_recognition_times[entity.emotion]
	var distance_mult = 0
	var distance = entity.position.distance_to(entity.player.position)

	for i in distance_recognition_ranges.size():
		if distance < distance_recognition_ranges[i]:
			distance_mult = distance_recognition_multipliers[i]
			break
	
	attack_timer.start(emotion_time*distance_mult)
