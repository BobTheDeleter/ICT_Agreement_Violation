class_name DeathState
extends "./_base_state.gd"

func _init(e).(e, "death"):
    pass

var vector_per_sec = Vector2.ZERO
func on_enter():
    vector_per_sec = (entity.monster.position-entity.position)/entity.monster.drag_time

func physics_update(delta):
    entity.position += vector_per_sec*delta
    entity.move_and_slide(Vector2.ZERO)