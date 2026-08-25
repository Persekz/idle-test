extends CharacterBody2D


@export var speed: float = 80
@export var max_health: int = 10

var health: int = max_health
var is_attacking: bool = false
var last_direction: Vector2 = Vector2.DOWN
var ataque: int = 10

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var area_attack: Area2D = $AreaAttack


func _physics_process(_delta: float) -> void:
	if is_attacking:
		velocity = Vector2.ZERO
	else:
		get_input()

	move_and_slide()
	animate()


func get_input() -> void:
	var x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_input = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	var input_vector = Vector2(x_input, y_input).normalized()
	velocity = input_vector * speed

	if input_vector != Vector2.ZERO:
		# Mantém apenas uma direção principal
		if abs(input_vector.x) > abs(input_vector.y):
			last_direction = Vector2.RIGHT if input_vector.x > 0 else Vector2.LEFT
		else:
			last_direction = Vector2.DOWN if input_vector.y > 0 else Vector2.UP

	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack()


func start_attack() -> void:
	is_attacking = true
	velocity = Vector2.ZERO

	anim_sprite.visible = false
	sprite.visible = true

	match last_direction:
		Vector2.UP:
			anim_player.play("SlashBack")
		Vector2.DOWN:
			anim_player.play("SlashFront")
		Vector2.LEFT:
			anim_player.play("SlashLeft")
		Vector2.RIGHT:
			anim_player.play("SlashRight")
		_:
			anim_player.play("SlashFront")


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with("Slash"):
		is_attacking = false
		sprite.visible = false
		anim_sprite.visible = true


func animate() -> void:
	if is_attacking:
		return

	if velocity == Vector2.ZERO:
		match last_direction:
			Vector2.UP:
				if anim_sprite.sprite_frames.has_animation("IdleBack"):
					anim_sprite.play("IdleBack")

			Vector2.DOWN:
				if anim_sprite.sprite_frames.has_animation("IdleFront"):
					anim_sprite.play("IdleFront")

			Vector2.LEFT:
				if anim_sprite.sprite_frames.has_animation("IdleLeft"):
					anim_sprite.play("IdleLeft")

			Vector2.RIGHT:
				if anim_sprite.sprite_frames.has_animation("IdleRight"):
					anim_sprite.play("IdleRight")
	else:
		var dir = velocity.normalized()

		if abs(dir.x) > abs(dir.y):
			anim_sprite.play("WalkRight" if dir.x > 0 else "WalkLeft")
		else:
			anim_sprite.play("WalkFront" if dir.y > 0 else "WalkBack")


func take_damage(amount: int) -> void:
	if health <= 0:
		return

	health -= amount

	if health <= 0:
		die()


func die() -> void:
	anim_sprite.play("Die")
	set_process(false)
	set_physics_process(false)
	
func _ready() -> void:
	print(anim_sprite.sprite_frames.get_animation_names())
