extends Control

var goal_pos
var player_pos

func _process(_delta):
    $TextureRect.set_position(goal_pos)