extends CharacterBody2D

signal died
signal hit_landed(position:Vector2, damage:int)
signal stats_changed

var hero_data := {}
var hero_name := "Hero"
var god := ""
var max_health := 100
var health := 100
var damage := 12
var speed := 220
var durability := 0
var attack_cooldown := 0.0
var special_cooldown := 0.0
var invincible_time := 0.0
var facing := 1
var combo := 0
var combo_timer := 0.0
var dash_time := 0.0
var attacking_time := 0.0
var attack_flash := 0.0
var lives := 2
var level := 1

@onready var sprite := $Sprite

# New preloads for camera shake and hitstop
const CameraShake := preload("res://scripts/camera_shake.gd")
const Hitstop := preload("res://scripts/hitstop.gd")

var cam_shake = null
var hitstop = null

func _ready():
	add_to_group("player")
	if hero_data:
		hero_name = hero_data["name"]
		god = hero_data["god"]
		max_health = int(hero_data["health"])
		health = max_health
		damage = int(hero_data["damage"])
		speed = int(hero_data["speed"])
		durability = int(hero_data["durability"])
		sprite.texture = load(hero_data["sprite"])
		sprite.scale = Vector2(float(hero_data.get("sprite_scale", 1.0)), float(hero_data.get("sprite_scale", 1.0)))
	z_index = int(position.y)

	# instantiate local hitstop and camera shake helpers so we don't require editor autoloads
	hitstop = Hitstop.new()
	add_child(hitstop)
	cam_shake = CameraShake.new()
	add_child(cam_shake)

func _physics_process(delta):
	z_index = int(position.y)
	attack_cooldown = max(0.0, attack_cooldown - delta)
	special_cooldown = max(0.0, special_cooldown - delta)
	invincible_time = max(0.0, invincible_time - delta)
	combo_timer = max(0.0, combo_timer - delta)
	dash_time = max(0.0, dash_time - delta)
	attacking_time = max(0.0, attacking_time - delta)
	attack_flash = max(0.0, attack_flash - delta)
	if combo_timer <= 0.0:
		combo = 0
	var input := Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	if input.length() > 1.0:
		input = input.normalized()
	if input.x != 0:
		facing = sign(input.x)
		sprite.flip_h = facing < 0
	var final_speed := float(speed) * (1.85 if dash_time > 0.0 else 1.0) * (0.72 if attacking_time > 0.0 else 1.0)
	velocity = input * final_speed
	move_and_slide()
	position.x = clamp(position.x, 45.0, 1235.0)
	position.y = clamp(position.y, 360.0, 665.0)
	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_just_pressed("special"):
		special()
	_update_visuals()
	queue_redraw()

func _update_visuals():
	if attacking_time > 0.0:
		sprite.rotation_degrees = -6.0 * facing
	else:
		sprite.rotation_degrees = 0.0
	if invincible_time > 0.0:
		sprite.modulate.a = 0.42 if int(invincible_time * 20.0) % 2 == 0 else 1.0
	else:
		sprite.modulate.a = 1.0

func attack():
	if attack_cooldown > 0.0:
		return
	combo = (combo % 3) + 1
	combo_timer = 0.9
	attacking_time = 0.16
	attack_flash = 0.12
	attack_cooldown = 0.24 if combo < 3 else 0.42
	var reach := 92.0 + float(combo) * 22.0
	var power := damage + combo * 5
	_damage_enemies_in_arc(reach, power)

func special():
	if special_cooldown > 0.0:
		return
	special_cooldown = 4.5
	attacking_time = 0.28
	match god:
		"Ares":
			_damage_enemies_in_arc(230.0, damage * 3 + 8)
		"Artemis":
			dash_time = 0.34
			_damage_enemies_in_arc(230.0, damage * 2 + 18)
		"Zeus":
			_damage_enemies_in_radius(265.0, damage * 2 + 24)
		"Hecate":
			_damage_enemies_in_radius(255.0, damage * 2 + 20)
		_:
			_damage_enemies_in_radius(190.0, damage * 2)

func _damage_enemies_in_arc(radius:float, amount:int):
	var any_hit := false
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(enemy):
			continue
		var to_enemy:Vector2 = enemy.position - position
		var same_lane: bool = abs(to_enemy.y) < 80.0
		var in_front: bool = sign(to_enemy.x) == facing or abs(to_enemy.x) < 38.0
		if same_lane and in_front and to_enemy.length() <= radius:
			enemy.take_damage(amount, Vector2(facing, -0.12))
			hit_landed.emit(enemy.global_position + Vector2(0, -34), amount)
			any_hit = true
	if any_hit:
		hit_landed.emit(global_position + Vector2(44 * facing, -40), amount)

func _damage_enemies_in_radius(radius:float, amount:int):
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(enemy):
			continue
		if position.distance_to(enemy.position) <= radius:
			enemy.take_damage(amount, (enemy.position - position).normalized())
			hit_landed.emit(enemy.global_position + Vector2(0, -34), amount)

func take_damage(amount:int):
	if invincible_time > 0.0:
		return
	invincible_time = 0.65
	var final_amount : int = max(1, amount - durability)
	health -= final_amount
	stats_changed.emit()
	if health <= 0:
		died.emit()
		queue_free()

func apply_upgrade(stat:String, amount:int):
	match stat:
		"damage": damage += amount
		"health":
			max_health += amount
			health = min(max_health, health + amount)
		"speed": speed += amount
		"durability": durability += amount
		"heal": health = min(max_health, health + amount)
		"level": level += amount
	stats_changed.emit()

func _draw():
	if attack_flash > 0.0:
		var alpha := attack_flash / 0.12
		var start := Vector2(18.0 * facing, -8.0)
		var end := Vector2((118.0 + combo * 18.0) * facing, -10.0)
		draw_line(start, end, Color(0.55, 0.85, 1.0, alpha), 8.0)
		draw_line(start + Vector2(0, 10), end + Vector2(0, 10), Color(1.0, 1.0, 1.0, alpha), 3.0)
