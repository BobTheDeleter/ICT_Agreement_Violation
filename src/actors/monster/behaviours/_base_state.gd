extends Reference

var entity

var speed

#initialising export vars and precaluclated values that will not change
func _init(e: KinematicBody2D):
    entity = e

#getting external data from entity/world before going into state. 
func on_enter():
    pass

#setting external data from entity/world before going into state.
func on_exit():
    pass

#to be called inside _process
func update(_delta):
    pass

#called when entity completes a path
func pathfind():
    pass