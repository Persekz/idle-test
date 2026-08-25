extends Node2D

var player_near: bool = false
var dialog_open: bool = false

var dialog_text := "Fala comigo ! Tome cuidado seu Animal!!"

@onready var caixa_dialogo = $CanvasLayer/CaixaDeDialogo
@onready var texto_dialogo = $CanvasLayer/CaixaDeDialogo/TextoDeDialogo
@onready var label_interact = $LabelInteract
@onready var timer = $CanvasLayer/Timer


func _ready() -> void:
	caixa_dialogo.visible = false
	texto_dialogo.visible = false
	label_interact.visible = false
	
	timer.timeout.connect(_on_timer_timeout)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		print("TECLA E FUNCIONOU")

		if player_near:
			print("PLAYER ESTÁ PERTO DO NPC")

			if not dialog_open:
				start_dialog()
			else:
				close_dialog()


func start_dialog() -> void:
	dialog_open = true

	label_interact.visible = false
	caixa_dialogo.visible = true
	texto_dialogo.visible = true

	texto_dialogo.text = dialog_text
	texto_dialogo.visible_characters = 0	

	print("Caixa visível: ", caixa_dialogo.visible)
	print("Texto visível: ", texto_dialogo.visible)
	print("Texto: ", texto_dialogo.text)

	timer.start()


func close_dialog() -> void:
	dialog_open = false
	
	timer.stop()
	
	caixa_dialogo.visible = false
	texto_dialogo.visible = false
	
	if player_near:
		label_interact.visible = true


func _on_area_interact_body_entered(body: Node2D) -> void:
	print("ENTROU NA AREA: ", body.name)

	if body.name == "Player":
		print("PLAYER DETECTADO!")
		player_near = true
		label_interact.visible = true


func _on_area_interact_body_exited(body: Node2D) -> void:
	print("SAIU DA AREA: ", body.name)

	if body.name == "Player":
		player_near = false
		label_interact.visible = false


func _on_timer_timeout() -> void:
	if texto_dialogo.visible_characters < texto_dialogo.text.length():
		texto_dialogo.visible_characters += 1
	else:
		timer.stop()
