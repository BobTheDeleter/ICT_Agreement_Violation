class_name ChaseState
extends "res://src/actors/_base_state.gd"

func _init(csf, e, rs, ar).(csf, e):
    run_speed = rs
    attack_radius = ar

func on_enter():
    player_last = entity.player_last_known

func on_exit():
    entity.player_last_known = player_last

var attack_radius
var line
var player_last
func update(_delta):    
    if entity.can_see_player():
        player_last = entity.player.position
        if  entity.position.distance_to(entity.player.position) < attack_radius:
            change_state_func.call_func("attack")
    else:
        change_state_func.call_func("investigate")

var run_speed
func physics_update(delta):
    entity.position += entity.position.direction_to(entity.player.position)*run_speed*delta
    entity.move_and_slide(Vector2.ZERO)