extends Reference
class_name BaseMonsterState

var entity: KinematicBody2D

var animation: String
var speed: int

#initialising export vars and precaluclated values that will not change
func _init(e: KinematicBody2D, s: int, a:String):
    entity = e
    speed = s
    animation = a

#getting external data from entity/world before going into state. 
func on_enter():
    pass

#setting external data from entity/world before leaving state.
func on_exit():
    pass

#to be called inside _process
func update(_delta):
    pass

#called when entity completes a path
func pathfind():
    pass