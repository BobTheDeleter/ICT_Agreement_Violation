extends Reference

var change_state_func: FuncRef

var entity

#initialising export vars and precaluclated values that will not change
func _init(csf: FuncRef, e: KinematicBody2D):
    change_state_func = csf
    entity = e

#getting external data from entity/world before going into state. 
func on_enter():
    pass

#setting external data from entity/world before going into state.
func on_exit():
    pass

#to be called inside _process
func update(_delta: float):
    pass

#to be called inside _physics_process
func physics_update(_delta: float):
    pass