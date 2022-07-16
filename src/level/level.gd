extends Node2D

export var player_layer   = 0b00010001
export var monster_layer = 0b00100001

# Called when the node enters the scene tree for the first time.
func _ready():
    $player.collision_layer = player_layer
    $monster.collision_layer = monster_layer

func player():
    return {
        "node": $player,
        "layer": player_layer,
    }
