class_name WalkState
extends "res://src/_base_state.gd"

var sprint_time
var walk_speed
var timer = Timer.new()
func _init(csf, e, st, s).(csf, e):
    e.add_child(timer)
    timer.connect("timeout", self, "_on_sprint_timer_timeout")
    sprint_time = st
    walk_speed = s

var input = Vector2()
var last_input = Vector2()
func update(_delta):
    input.x = Input.get_axis("ui_left", "ui_right") 
    input.y = Input.get_axis("ui_up", "ui_down")
    
    if input == last_input && input.length()>0 && timer.is_stopped():
        timer.start(sprint_time)
    elif input != last_input:
        timer.stop()

    last_input = input

func physics_update(delta):
    entity.position += input.normalized()*walk_speed*delta
    entity.move_and_slide(Vector2.ZERO)

func _on_sprint_timer_timeout():
    timer.stop()
    change_state_func.call_func("sprint")
