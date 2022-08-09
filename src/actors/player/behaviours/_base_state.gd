extends Reference
class_name BasePlayerState

var entity: KinematicBody2D
var animation: String

#initialising export vars and precaluclated values that will not change
func _init(e: KinematicBody2D, a: String):
    entity = e
    animation = a

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