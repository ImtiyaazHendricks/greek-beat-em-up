extends CharacterBody2D

signal killed(reward:int)
signal damaged(position:Vector2, amount:int)

var enemy_name := "Skeleton"
var max_health := 50
var health := 50
var damage := 8
var speed := 90
var reward_gold := 3
var attack_timer := 0.0
var knockback := Vector2.ZERO
var is_boss := false
var hurt_flash := 0.0

@onready var sprite := $Sprite

func _ready():
	add_to_group("enemies")
	health = max_health
	z_index = int(position.y)

func configure(data:Dictionary, stage:int):
	enemy_name = data["name"]
	max_health = int(data["health"]) + stage * int(data["scale_hp"])
	health = max_health
	damage = int(data["damage"]) + stage * int(data["scale_damage"])
	speed = int(data["speed"]) + stage * 4
	reward_gold = int(data["gold"]) + stage
	is_boss = bool(data.get("boss", false))
	if has_node("Sprite"):
		$Sprite.texture = load(data["sprite"])
	if is_boss:
		scale = Vector2(1.8, 1.8)
	else:
		scale = Vector2.ONE

func _physics_process(delta):
	z_index = int(position.y)
	attack_timer = max(0.0, attack_timer - delta)
	hurt_flash = max(0.0, hurt_flash - delta)
	var players := get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return
	var player = players[0]
	var dist := position.distance_to(player.position)
	if knockback.length() > 8.0:
		velocity = knockback
		knockback = knockback.move_toward(Vector2.ZERO, delta * 1000.0)
		move_and_slide()
		return
	var desired_range := 80.0 if is_boss else 58.0
	if dist > desired_range or abs(player.position.y - position.y) > 42.0:
		velocity = (player.position - position).normalized() * speed
		move_and_slide()
		sprite.flip_h = velocity.x < 0
	else:
		velocity = Vector2.ZERO
		if attack_timer <= 0.0:
			attack_timer = 0.78 if not is_boss else 1.08
			player.take_damage(damage)
	_update_visuals()
	queue_redraw()

func _update_visuals():
	if hurt_flash > 0.0:
		sprite.modulate = Color(1.0, 0.45, 0.45)
	else:
		sprite.modulate = Color.WHITE

func take_damage(amount:int, direction:=Vector2.RIGHT):
	health -= amount
	hurt_flash = 0.1
	knockback = direction.normalized() * (245.0 if not is_boss else 125.0)
	damaged.emit(global_position + Vector2(0, -36), amount)
	if health <= 0:
		killed.emit(reward_gold)
		queue_free()

func _draw():
	var w := 66.0 if not is_boss else 92.0
	var hp_ratio : float = clamp(float(health) / float(max_health), 0.0, 1.0)
	draw_rect(Rect2(Vector2(-w * 0.5, -78.0), Vector2(w, 7.0)), Color(0.08, 0.02, 0.02, 0.85))
	draw_rect(Rect2(Vector2(-w * 0.5, -78.0), Vector2(w * hp_ratio, 7.0)), Color(0.85, 0.05, 0.03, 0.95))
