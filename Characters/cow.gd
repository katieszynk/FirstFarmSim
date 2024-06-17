extends CharacterBody2D

enum COW_STATE { IDLE, WALK, SLEEP }

@export var move_speed : float = 20
@export var idle_time: float = 5
@export var walk_time : float = 3
@export var sleep_time : float = 8

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var timer = $Timer

var move_direction : Vector2 = Vector2.ZERO
var current_state : COW_STATE = COW_STATE.IDLE

func _ready():
	pick_new_state()

func _physics_process(_delta):
	if (current_state == COW_STATE.WALK):
		velocity = move_direction * move_speed
		move_and_slide()

func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	
	if (move_direction.x < 0):
		sprite.flip_h = true
	elif(move_direction.x > 0):
		sprite.flip_h = false
	
func pick_new_state():
	if (current_state == COW_STATE.IDLE || current_state == COW_STATE.SLEEP):
		state_machine.travel("walk")
		current_state = COW_STATE.WALK
		select_new_direction()
		timer.start(walk_time)
	elif (current_state == COW_STATE.WALK):
		var random_idle_state = randi_range(0, 3)
		if (random_idle_state > 0):
			state_machine.travel("idle")
			current_state = COW_STATE.IDLE
			timer.start(idle_time)
		elif (random_idle_state == 0):
			state_machine.travel("sleep")
			current_state = COW_STATE.SLEEP
			timer.start(sleep_time)


func _on_timer_timeout():
	pick_new_state()
