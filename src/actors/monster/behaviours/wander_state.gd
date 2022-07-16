class_name WanderState
extends "res://src/_base_state.gd"

func _init(csf, e, pd, wa, s, p, ss).(csf, e):
    point_distance = pd
    waypoint_array = wa
    nav2d = entity.get_parent().get_node("Navigation2D")
    speed = s
    space_state = ss
    player = p

var point_distance
var waypoint_array
var current_wp
var current_path = PoolVector2Array()
var nav2d
func update(_delta):
    if can_see_player():
        change_state_func.call_func("investigate")
    if current_path.size() < 1:
        get_path()

var speed
func physics_update(delta):
    if current_path.size() > 0:
      entity.position += entity.position.direction_to(current_path[0])*speed*delta
      entity.move_and_slide(Vector2.ZERO)
        
      if entity.position.distance_to(current_path[0]) < point_distance:
          current_path.remove(0)
    else:
        entity.emotion = max(entity.emotion-1, 0)

func get_path():
    current_wp = waypoint_array[ randi()%(waypoint_array.size()) ]
    current_path = nav2d.get_simple_path(entity.position, current_wp.position, false)
    entity.wpdebug.points = current_path

var space_state
var player
func can_see_player():
    var result = space_state.intersect_ray(entity.global_position, player.node.global_position, [self])
    if result:
        entity.vdebug.points = [result.position, entity.position]
        if result.collider == player.node:
            return true
    return false