extends KinematicBody2D

export var walk_speed = 1
export var sprint_time = 0.5

export var sprint_multiplier = 1.5 
export var sprint_accel_time = 2

var layer

var STATES
var _state
func _ready():
    STATES = {
        "walk": WalkState.new(self, walk_speed),
        "sprint": SprintState.new(self, sprint_accel_time, walk_speed, sprint_multiplier),
        "death": DeathState.new(self),
    }
    _state = STATES["walk"]
    _state.on_enter()

func _process(delta):
    _state.update(delta)

func _physics_process(delta):
    _state.physics_update(delta)

func change_state(state):
    _state.on_exit()
    _state = STATES[state]
    _state.on_enter()

func die(vps):
    change_state("death")
    _state._on_enter_death(vps)
