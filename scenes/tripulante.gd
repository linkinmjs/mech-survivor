extends CharacterBody2D

@onready var player = $Tripulante
@onready var sprite = $Sprite2D
@onready var camera = $Camera2D
@onready var mecha = get_parent().get_node("TowerMecha")  # Referencia al mecha. TODO: mejorar

var current_state:STATE = STATE.RUNNING
var movement_speed = 40.0
var is_mounted = false

enum STATE{
	IDLE,
	RUNNING,
	SHOOTING,
	DRIVING
}

func _ready():
	change_state(STATE.IDLE)
	camera.zoom = Vector2(2, 2)

func _process(delta: float) -> void:
		# Detectar si está en el rango para montarse al mecha
	if Input.get_action_strength("A_button") and not is_mounted:
		mount_mecha()
	elif Input.get_action_strength("B_button") and is_mounted:
		dismount_mecha()
	

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

func mount_mecha():
	if mecha:
		is_mounted = true
		camera.get_parent().remove_child(camera)
		mecha.add_child(camera)  # Mueve la cámara al mecha
		camera.position = Vector2.ZERO  # Centra la cámara en el mecha
		camera.zoom = Vector2(1, 1)
		visible = false  # Oculta al tripulante
		set_physics_process(false)  # Desactiva física para el tripulante
		mecha.is_controlled = true

func dismount_mecha():
	if is_mounted:
		camera.get_parent().remove_child(camera)
		add_child(camera)  # Retorna la cámara al tripulante
		camera.position = Vector2.ZERO
		camera.zoom = Vector2(2, 2)
		visible = true  # Muestra al tripulante
		set_physics_process(true)  # Reactiva la física para el tripulante
		mecha.is_controlled = false
		is_mounted = false
