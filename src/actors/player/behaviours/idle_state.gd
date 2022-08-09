class_name IdleState
extends "./_base_state.gd"

func _init(e).(e, "idle"):
    pass

var input = Vector2()
func update(_delta):
        input.x = Input.get_axis("ui_left", "ui_right") 
        input.y = Input.get_axis("ui_up", "ui_down")

        if input.length():
            entity.change_state("walk")