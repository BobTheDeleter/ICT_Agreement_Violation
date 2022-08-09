extends Control

var score = 0
var goal_rot = 0.0
var monster_rot = 0.0

func _process(_delta):
	$goal.set_rotation(goal_rot)
	$monster.set_rotation(monster_rot)
	$points.text = String(score)
