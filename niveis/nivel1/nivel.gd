extends Node2D

onready var player = get_node("player")
onready var camera2d = get_node("Camera2D")
onready var tween = get_node("Camera2D/Tween")
onready var nivel = get_node("res://nivel.tscn/nivel")

func _ready():
	MusicaControle.tocar()
	$fade_out.color = Color(0,0,0,0)
	player.motion.y = 500
	$player/Sprite.flip_h = true
	yield(get_tree().create_timer(1.5),"timeout")
	transition_camera2D(camera2d, $player/Camera2D, 1.5)
	yield(get_tree().create_timer(2),"timeout")
	mostrar_tecla()
	player.simulacao = true
	player.motion.y = 0

func mostrar_tecla():
	$Sprite.show()
	

func _process(delta):
	if Input.is_action_pressed("attack"):
		yield(get_tree().create_timer(0.5),"timeout")
		$Sprite.hide()

func switch_camera(from, to) -> void:
	from.current = false
	to.current = true

func transition_camera2D(from: Camera2D, to: Camera2D, duration: float = 2.5) -> void:
	yield(get_tree().create_timer(0.3), "timeout")
	var transitioning = false
	if transitioning: return
	camera2d.zoom = from.zoom
	camera2d.offset = from.offset
	
	camera2d.global_transform = from.global_transform
	
	camera2d.current = true
	transitioning = true

	tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera2d, "global_transform", to.global_transform, duration).from(camera2d.global_transform)
	tween.tween_property(camera2d, "zoom", to.zoom, duration).from(camera2d.zoom)
#	tween.tween_property(camera2d, "fov", to.fov, duration).from(camera2d.fov)
	
	yield(get_tree().create_timer(duration), "timeout")
	
	to.current = false
	transitioning = false
	
	to.current = true


func _on_dano_body_entered(body):
	if body == player:
		$fade_out.color = Color(0,0,0,1)
		MusicaControle.reiniciar()
		yield(get_tree().create_timer(1.5), "timeout")
		get_tree().change_scene("res://niveis/nivel1/nivel.tscn")


func _on_passar_nivel_body_entered(body):
	if body == $player:
		get_tree().change_scene("res://niveis/nivel2/nivel.tscn")
