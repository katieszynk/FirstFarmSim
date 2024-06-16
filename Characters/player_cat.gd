extends CharacterBody2D

#@export var move_speed : float = 100
#@export var starting_direction : Vector2 = Vector2(0, 1)
const ACCELERATION = 800
const FRICTION = 1000
const MAX_SPEED = 120

enum {IDLE, WALK}
var state = IDLE

var blend_position : Vector2 = Vector2.ZERO
var blend_pos_paths = [
	"parameters/Idle/idle_bs2d/blend_position",
	"parameters/Walk/walk_bs2d/blend_position"
]
var animTree_state_keys = [
	"Idle",
	"Walk"
]
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

func _physics_process(delta):
	move(delta)
	animate()
	
func move(delta):
	var input_vector = Input.get_vector("left", "right", "up", "down")
	if (input_vector == Vector2.ZERO):
		state = IDLE
		apply_friction(FRICTION * delta)
	else:
		state = WALK
		apply_movement(input_vector * ACCELERATION * delta)
		blend_position = input_vector
	move_and_slide()
	
func apply_friction(amount) -> void:
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
		
func apply_movement(amount) -> void:
	velocity += amount
	velocity = velocity.limit_length(MAX_SPEED)
	
func animate() -> void:
	state_machine.travel(animTree_state_keys[state])
	animation_tree.set(blend_pos_paths[state], blend_position)

#func _ready():
	#animation_tree.set_active(true)
	#update_animation_parameters(starting_direction)

#func _physics_process(_delta):
	## Get Input Direction
	#var input_direction = Input.get_vector("left", "right", "up", "down")
	#update_animation_parameters(input_direction)
#
	## Update Velocity
	#velocity = input_direction.normalized() * move_speed
	#update_animation_parameters(input_direction)
	## Use Move and Slide Function to slide when colliding
	#move_and_slide()
	#
	#pick_new_state()
#
#func update_animation_parameters(move_input : Vector2) :
	#if (move_input != Vector2.ZERO):
		#animation_tree.set("parameters/Walk/blend_position", move_input)
		#animation_tree.set("parameters/Idle/blend_position", move_input)
#
#func pick_new_state():
	#if (velocity != Vector2.ZERO):
		#state_machine.travel("Walk", false)
	#else:
		#state_machine.travel("Idle", false)
