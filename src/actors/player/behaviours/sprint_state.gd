class_name SprintState
extends "./_base_state.gd"

var speed
var sprint_speed
var accel_per_sec
func _init(e, a, w, s).(e, "run"):
    speed = w
    sprint_speed = w*s
    accel_per_sec = (w*(s-1))/a

var input = Vector2()
func update(_delta):
    input.x = Input.get_axis("ui_left", "ui_right") 
    input.y = Input.get_axis("ui_up", "ui_down")

    if !input.length():
        entity.change_state("walk")

    if !Input.is_action_pressed("ui_accept"):
        entity.change_state("walk")

func physics_update(delta):
    if speed < sprint_speed:
        speed += accel_per_sec*delta
    else:
        speed = sprint_speed

    entity.position += input.normalized()*speed*delta
    entity.move_and_slide(Vector2.ZERO)
