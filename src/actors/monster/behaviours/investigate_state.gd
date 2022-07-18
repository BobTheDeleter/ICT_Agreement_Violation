class_name InvestigateState
extends "res://src/actors/_base_state.gd"

func _init(csf, e, ss, ert, drm, drr, pr, ar).(csf, e):
    search_speed = ss
    emotion_recognition_times = ert
    distance_recognition_multipliers = drm
    distance_recognition_ranges = drr
    wp_radius = pr
    attack_radius = ar

    e.add_child(attack_timer)
    attack_timer.one_shot = true

func on_enter():
    player_last = entity.player_last_known
    start_attack_timer()

func on_exit():
    entity.emotion = min(entity.emotion+1, entity.emotion_recognition_times.size()-1)
    entity.player_last_known = player_last
    attack_timer.stop()

var emotion_recognition_times
var distance_recognition_multipliers
var distance_recognition_ranges
var attack_timer = Timer.new()
var player_last = Vector2.ZERO
func update(_delta):
    var can_see_player = entity.can_see_player()
    
    if entity.position.distance_to(entity.player.position) < attack_radius && can_see_player:
        change_state_func.call_func("chase")

    if attack_timer.is_stopped():
        change_state_func.call_func("chase")
        
    if entity.position.distance_to(player_last) < wp_radius:
        change_state_func.call_func("search")

    if can_see_player:
        player_last = entity.player.position
        if attack_timer.is_stopped():
            start_attack_timer()

var search_speed
var wp_radius
var attack_radius
func physics_update(delta):
    entity.position += entity.position.direction_to(player_last)*search_speed*delta
    entity.move_and_slide(Vector2.ZERO)

func start_attack_timer():
    var emotion_time = emotion_recognition_times[entity.emotion]
    var distance_mult = 0
    var distance = entity.position.distance_to(entity.player.position)

    for i in distance_recognition_ranges.size():
        if distance < distance_recognition_ranges[i]:
            distance_mult = distance_recognition_multipliers[i]
            break
    
    attack_timer.start(emotion_time*distance_mult)