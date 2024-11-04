extends CharacterBody2D

# Cremos referencia del player al que vamos a controlar
@onready var player = $Tripulante
@onready var sprite = $Sprite2D

var current_state:STATE = STATE.RUNNING
var movement_speed = 40.0

enum STATE{
	IDLE,
	RUNNING,
	SHOOTING,
	DRIVING
}

func _ready():
	change_state(STATE.IDLE)

func _physics_process(delta):
	# Movimiento del personaje
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)

	# Cambiar estado
	if mov != Vector2.ZERO:
		change_state(STATE.RUNNING)
	else:
		change_state(STATE.IDLE)

	# Animación de Flip
	if mov.x > 0:
		sprite.flip_h = false
	elif mov.x < 0:
		sprite.flip_h = true
		
	# Aplicar movimiento
	velocity = mov.normalized() * movement_speed
	move_and_slide()

func change_state(new_state: STATE):
	if current_state != new_state:
		current_state = new_state
		match current_state:
			STATE.IDLE:
				$AnimationPlayer.play("idle")
			STATE.RUNNING:
				$AnimationPlayer.play("running")
