extends KinematicBody2D

enum { MOVE, CHARGE, JUMP }
const GRAVITY = 800.0
const MAX_JUMP_SPEED = -400.0
const MOVE_SPEED = 80.0
const AIR_MOVE_SPEED = 150.0
const LIE_SPEED = 350.0

var state = MOVE
var velocity = Vector2(0, 0)

onready var jump_man_animation = $JumpManAnimation
onready var timer = $Timer

func _ready():
	timer.connect('timeout', self, 'jump', [1.0])

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	move_and_slide(velocity, Vector2.UP)

	if state == MOVE:
		if !is_on_floor():
			state = JUMP
			jump_man_animation.play_fall()

	if state == JUMP:
		if velocity.y > 0:
			if !jump_man_animation.is_hit():
				jump_man_animation.play_fall()
		if is_on_floor():
			state = MOVE
			velocity.x = 0
			jump_man_animation.play_idle()
		if is_on_ceiling():
			velocity.x = velocity.x / 2
			jump_man_animation.play_hit()
		if is_on_wall():
			velocity.x = velocity.x / -2
			jump_man_animation.play_hit()

	if is_on_floor():
		if velocity.y > LIE_SPEED:
			jump_man_animation.play_lie()
		velocity.y = 0
	if is_on_ceiling():
		velocity.y = 0

func _input(event):
	match state:
		MOVE:
			handle_move_input()
		CHARGE:
			handle_charge_input()

func handle_move_input():
	if Input.is_action_just_pressed('jump'):
		state = CHARGE
		velocity.x = 0
		timer.start()
		jump_man_animation.play_charge()
	elif Input.is_action_pressed('move_left'):
		velocity.x = -MOVE_SPEED
		jump_man_animation.play_left_walk()
	elif Input.is_action_pressed('move_right'):
		velocity.x = MOVE_SPEED
		jump_man_animation.play_right_walk()
	else:
		velocity.x = 0
		jump_man_animation.play_idle()

func handle_charge_input():
	if Input.is_action_just_released('jump'):
		var elapsed_time = timer.wait_time - timer.time_left
		var power = elapsed_time / timer.wait_time
		timer.stop()
		jump(power)

func jump(power):
	state = JUMP
	velocity.y = MAX_JUMP_SPEED * (power / 2 + 0.5)
	if Input.is_action_pressed('move_left'):
		velocity.x = -AIR_MOVE_SPEED
		jump_man_animation.play_left_jump()
	elif Input.is_action_pressed('move_right'):
		velocity.x = AIR_MOVE_SPEED
		jump_man_animation.play_right_jump()
	else:
		jump_man_animation.play_jump()
