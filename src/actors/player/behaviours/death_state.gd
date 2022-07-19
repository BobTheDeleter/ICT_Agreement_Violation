class_name DeathState
extends "./_base_state.gd"

func _init(e).(e):
    pass

var vector_per_sec =Vector2.ZERO
func _on_enter_death(vps):
    vector_per_sec = vps

var drag_time
func update(delta):
    entity.position += vector_per_sec*delta
    entity.move_and_slide(Vector2.ZERO)