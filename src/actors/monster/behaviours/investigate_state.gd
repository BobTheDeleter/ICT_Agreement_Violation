class_name InvestigateState
extends "res://src/actors/_base_state.gd"

func _init(csf, e, rs, ss, p, ert, drm, drr, pr, ar).(csf, e):
    run_speed = rs
    space_state = ss
    player = p
    emotion_recognition_times = ert
    distance_recognition_multipliers = drm
    distance_recognition_ranges = drr
    wp_radius = pr
    attack_radius = ar

    e.add_child(attack_timer)
    attack_timer.connect("timeout", self, "_on_attack_timeout")
    attack_timer.one_shot = true

func _on_enter():
    start_attack_timer()
    player_last = entity.player.position

func start_attack_timer():
    var emotion_time = emotion_recognition_times[entity.emotion]
    var distance_mult = 0
    var distance = entity.position.distance_to(entity.player.position)

    for i in distance_recognition_ranges.size():
        if distance < distance_recognition_ranges[i]:
            distance_mult = distance_recognition_multipliers[i]
            break
    
    attack_timer.start(emotion_time*distance_mult)

func _on_exit():
    entity.emotion = min(entity.emotion+1, entity.emotion_recognition_times.size()-1)
    attack_timer.stop()

var emotion_recognition_times
var distance_recognition_multipliers
var distance_recognition_ranges
var attack_timer = Timer.new()
var player_last = Vector2.ZERO
var can_see_player = false
func update(_delta):
    var pos = player_los_check()
    if pos is Vector2:
        can_see_player = true
        player_last = pos
        if attack_timer.is_stopped():
            start_attack_timer()
    else:
        can_see_player = false
        attack_timer.stop()

var run_speed
var wp_radius
var attack_radius
func physics_update(delta):
    entity.position += entity.position.direction_to(player_last)*run_speed*delta
    entity.move_and_slide(Vector2.ZERO)
      
    if entity.position.distance_to(player_last) < wp_radius:
        change_state_func.call_func("wander")
        #TODO Search state
        pass

    if entity.position.distance_to(entity.player.position) < attack_radius && can_see_player:
        change_state_func.call_func("attack")
    
var space_state
var player_coll_layer
var player
func player_los_check():
    #TODO max range
    var result = space_state.intersect_ray(entity.global_position, player.global_position, [self])
    if result:
        if result.collider == player:
            return result.position
        entity.vdebug.points = [result.position, entity.position]
        
    return false

func _on_attack_timeout():
    change_state_func.call_func("attack")