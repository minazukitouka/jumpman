extends AnimatedSprite

func play_idle():
	play('Idle')

func play_left_walk():
	flip_h = true
	play('Walk')

func play_right_walk():
	flip_h = false
	play('Walk')

func play_charge():
	play('Crouch')

func play_jump():
	if animation != 'Jump':
		play('Jump')

func play_left_jump():
	flip_h = true
	play_jump()

func play_right_jump():
	flip_h = false
	play_jump()

func play_fall():
	if animation != 'Fall':
		play('Fall')

func play_hit():
	if !is_hit():
		play('Hit')

func play_left_hit():
	flip_h = true
	play_hit()

func play_right_hit():
	flip_h = false
	play_hit()

func is_hit():
	return animation == 'Hit'

func play_lie():
	play('Lie')
