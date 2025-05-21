extends CharacterBody3D

#Components
@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

#In Scene
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("Player")

#Constants
const GRAVITY = 9.8

#Tweakable vars
@export var move_speed = 4.0
@export var attack_range = 2.0

var is_dead = false

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	var dir = player.global_position - global_position
	dir.y = 0
	dir = dir.normalized()
	
	velocity = dir * move_speed
	velocity.y += -GRAVITY * delta
	
	move_and_slide()
	shoot_at_player()
	
func take_damage():
	is_dead = true
	
func shoot_at_player():
	pass
