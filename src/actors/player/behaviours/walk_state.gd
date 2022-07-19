class_name WalkState
extends "./_base_state.gd"

var sprint_time
var walk_speed
func _init(e, s).(e):
    walk_speed = s

var input = Vector2()
func update(_delta):
    input.x = Input.get_axis("ui_left", "ui_right") 
    input.y = Input.get_axis("ui_up", "ui_down")
    
    if Input.is_action_just_pressed("ui_accept"):
        entity.change_state("sprint")

func physics_update(delta):
    entity.position += input.normalized()*walk_speed*delta
    entity.move_and_slide(Vector2.ZERO)
