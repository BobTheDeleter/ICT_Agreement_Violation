extends KinematicBody2D

export var speed = 100

export var search_speed = 350

export var sight_range = 0

export var alert_rec_times = PoolIntArray()
export var dist_rec_mults = PoolRealArray()
export var dist_rec_ranges = PoolIntArray()

export var attack_range = 0
export var drag_time = 0
export var run_speed = 0

export var search_points = 0
export var search_radii = PoolIntArray()

onready var level = get_parent()

onready var player = level.player()

onready var wp_radius = $CollisionShape2D.shape.radius + 10

onready var space_state = get_world_2d().direct_space_state
onready var nav2D = level.nav2D()

onready var animator = $AnimationPlayer
#debug
onready var wpdebug = $"../wpdebug"
onready var vdebug = $"../vdebug"

var STATES
var _state: BaseMonsterState

signal wander
signal investigate
signal chase
signal search
signal attack

func _ready():
	STATES = {
		"wander": WanderState.new(self, speed),
		"investigate": InvestigateState.new(self, search_speed, alert_rec_times, dist_rec_mults, dist_rec_ranges, attack_range),
		"chase": ChaseState.new(self, run_speed, attack_range),
		"search": SearchState.new(self, search_speed, search_radii, search_points),
		"attack": AttackState.new(self, 0),
	}
	_state = STATES["wander"]
	_state.on_enter()

func change_state(state):
	_state.on_exit()
	_state = STATES[state]
	_state.on_enter()
	emit_signal(state)

func _process(delta):
	_state.update(delta)
	animate(_state.animation)

var current_path = PoolVector2Array()
func _physics_process(delta):
	if current_path.size() > 0:
		position += position.direction_to(current_path[0])*_state.speed*delta
		move_and_slide(Vector2.ZERO)
		  
		if position.distance_to(current_path[0]) < wp_radius:
			current_path.remove(0)

	else:
		_state.pathfind()

func animate(name):
	pass
#region used by state
var emotion = 0
var player_last_known = Vector2()

func can_see_player():
	var result = space_state.intersect_ray(position, player.position, [self])
	if result:
		if result.collider == player && position.distance_to(result.position) < sight_range:
			return true
		vdebug.points = [result.position, position]
		
	return false

func raycast(p1, p2):
	return space_state.intersect_ray(p1, p2)

func pathfind(p1, p2):
	wpdebug.points = nav2D.get_simple_path(p1, p2, false)
	return nav2D.get_simple_path(p1, p2, false)
#endregion

#TODO add handler for tenseness(?) level, possibly external, probably internal
