extends KinematicBody2D

export var walk_speed = 1

export var sprint_multiplier = 1.5 
export var sprint_accel_time = 2

export var goal_range = 0

onready var level = get_parent()
onready var monster = level.monster()
onready var goals = level.goals()
onready var goal_distance = $CollisionShape2D.shape.height+goal_range

onready var hud = get_tree().get_root().get_node("./main/ui/hud_layer/hud")
onready var world_ui = get_tree().get_root().get_node("./main/ui/world_ui")

var goal = Vector2()

var STATES
var _state: BasePlayerState
func _ready():
	monster.connect("attack", self, "die")

	STATES = {
		"idle": IdleState.new(self),
		"walk": WalkState.new(self, walk_speed),
		"sprint": SprintState.new(self, sprint_accel_time, walk_speed, sprint_multiplier),
		"death": DeathState.new(self),
	}
	_state = STATES["idle"]
	_state.on_enter()

	get_new_goal()

var has_played_death = false
func _process(delta):
	_state.update(delta)
	
	monster_indicator()
	goal_indicator()

	if _state.animation == "death":
		if !has_played_death:
			$AnimationPlayer.play("death")
			has_played_death = true
	else:
		$AnimationPlayer.play(_state.animation)
		if _state.input.x >= 0:
			$sprites.scale.x = 1
		else:
			$sprites.scale.x = -1

func _physics_process(delta):
	_state.physics_update(delta)

	if position.distance_to(goal) < goal_distance:
		get_new_goal()
		hud.score += 1

func change_state(state):
	_state.on_exit()
	_state = STATES[state]
	_state.on_enter()

func die():
	change_state("death")

func monster_indicator():
	var v = position.direction_to(monster.position)
	if v.x > 0:
		hud.monster_rot = atan(v.y/v.x)
	else:
		hud.monster_rot = PI+atan(v.y/v.x)

func goal_indicator():
		var v = position.direction_to(goal)
		if v.x > 0:
			hud.goal_rot = atan(v.y/v.x)
		else:
			hud.goal_rot = PI+atan(v.y/v.x)
	
func get_new_goal():
	goal = goals[ randi()%goals.size() ].position
	world_ui.goal_pos = goal
