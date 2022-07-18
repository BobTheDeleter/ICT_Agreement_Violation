class_name WalkState
extends "res://src/actors/_base_state.gd"

var sprint_time
var walk_speed
func _init(csf, e, s).(csf, e):
    walk_speed = s

var input = Vector2()
func update(_delta):
    input.x = Input.get_axis("ui_left", "ui_right") 
    input.y = Input.get_axis("ui_up", "ui_down")
    
    if Input.is_action_just_pressed("ui_accept"):
        change_state_func.call_func("sprint")

func physics_update(delta):
    entity.position += input.normalized()*walk_speed*delta
    entity.move_and_slide(Vector2.ZERO)