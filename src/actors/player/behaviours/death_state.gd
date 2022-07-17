class_name DeathState
extends "res://src/actors/_base_state.gd"

func _init(csf, e).(csf, e):
    pass

var vector_per_sec =Vector2.ZERO
func _on_enter_death(vps):
    vector_per_sec = vps

var drag_time
func update(delta):
    entity.position += vector_per_sec*delta
    entity.move_and_slide(Vector2.ZERO)