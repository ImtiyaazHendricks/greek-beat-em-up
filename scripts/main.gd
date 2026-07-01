extends Node2D

const PlayerScene := preload("res://scenes/Player.tscn")
const EnemyScene := preload("res://scenes/Enemy.tscn")
const UpgradeCardScene := preload("res://scenes/UpgradeCard.tscn")
const SparkScene := preload("res://scripts/hit_spark.gd")
const FloatingTextScene := preload("res://scripts/floating_text.gd")

var heroes := [
	{"name":"Perseus", "god":"Ares", "health":145, "damage":20, "speed":238, "durability":4, "sprite":"res://assets/hero_leonidas.png", "role":"sword / shield bruiser", "sprite_scale":1.15},
	{"name":"Athena", "god":"Athena", "health":125, "damage":17, "speed":270, "durability":6, "sprite":"res://assets/hero_atalanta.png", "role":"balanced spear guard", "sprite_scale":1.12},
	{"name":"Hercules", "god":"Zeus", "health":190, "damage":28, "speed":188, "durability":7, "sprite":"res://assets/hero_herakles.png", "role":"slow powerhouse", "sprite_scale":1.18},
	{"name":"Artemis", "god":"Artemis", "health":100, "damage":15, "speed":325, "durability":1, "sprite":"res://assets/hero_medea.png", "role":"fast hunter", "sprite_scale":1.10}
]

var enemy_types := [
	{"name":"Skeleton", "sprite":"res://assets/enemy_skeleton.png", "health":42, "damage":6, "speed":98, "gold":3, "scale_hp":9, "scale_damage":1},
	{"name":"Satyr", "sprite":"res://assets/enemy_satyr.png", "health":58, "damage":8, "speed":118, "gold":4, "scale_hp":10, "scale_damage":1},
	{"name":"Harpy", "sprite":"res://assets/enemy_harpy.png", "health":44, "damage":7, "speed":152, "gold":4, "scale_hp":8, "scale_damage":1},
	{"name":"Minotaur", "sprite":"res://assets/enemy_minotaur.png", "health":115, "damage":15, "speed":84, "gold":8, "scale_hp":18, "scale_damage":2}
]
var boss_type := {"name":"Hydra", "sprite":"res://assets/boss_hydra.png", "health":420, "damage":22, "speed":76, "gold":42, "scale_hp":70, "scale_damage":3, "boss":true}

var stage := 1
var gold := 0
var score := 0
var combo_hits := 0
var combo_timer := 0.0
var enemies_left := 0
var chosen_hero := 0
var player:Node = null
var state := "select"
var rng := RandomNumberGenerator.new()

@onready var background := $Background
@onready var title_screen := $TitleScreen

var ui:CanvasLayer
var top_bar:ColorRect
var hero_labels:Array[Label] = []
var message_label:Label
var enemy_label:Label
var combo_label:Label
var bottom_label:Label
var hero_portraits:Array[TextureRect] = []
var select_cards:Array[Node] = []

func _ready():
	rng.randomize()
	_setup_ui()
	_show_character_select()

func _process(delta):
	combo_timer = max(0.0, combo_timer - delta)
	if combo_timer <= 0.0:
		combo_hits = 0
	if state == "select":
		for i in range(4):
			if Input.is_action_just_pressed("select_%d" % (i + 1)):
				_start_run(i)
	elif state == "playing":
		_update_arcade_ui()
		if enemies_left <= 0 and get_tree().get_nodes_in_group("enemies").is_empty():
			_stage_clear()
	elif state == "upgrade":
		_update_arcade_ui()

func _setup_ui():
	ui = CanvasLayer.new()
	add_child(ui)
	top_bar = ColorRect.new()
	top_bar.color = Color(0.02, 0.02, 0.04, 0.82)
	top_bar.size = Vector2(1280, 122)
	ui.add_child(top_bar)
	for i in range(4):
		var label := Label.new()
		label.position = Vector2(102 + i * 300, 10)
		label.size = Vector2(255, 95)
		label.add_theme_font_size_override("font_size", 22)
		label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.48))
		label.add_theme_color_override("font_shadow_color", Color.BLACK)
		label.add_theme_constant_override("shadow_offset_x", 3)
		label.add_theme_constant_override("shadow_offset_y", 3)
		ui.add_child(label)
		hero_labels.append(label)
		var portrait := TextureRect.new()
		portrait.position = Vector2(18 + i * 300, 12)
		portrait.size = Vector2(72, 72)
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.texture = load(heroes[i]["sprite"])
		ui.add_child(portrait)
		hero_portraits.append(portrait)
	enemy_label = Label.new()
	enemy_label.position = Vector2(20, 126)
	enemy_label.size = Vector2(340, 64)
	enemy_label.add_theme_font_size_override("font_size", 26)
	enemy_label.add_theme_color_override("font_color", Color(1.0, 0.94, 0.74))
	enemy_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	enemy_label.add_theme_constant_override("shadow_offset_x", 3)
	enemy_label.add_theme_constant_override("shadow_offset_y", 3)
	ui.add_child(enemy_label)
	message_label = Label.new()
	message_label.position = Vector2(385, 132)
	message_label.size = Vector2(520, 90)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.add_theme_font_size_override("font_size", 30)
	message_label.add_theme_color_override("font_color", Color(0.78, 0.86, 1.0))
	message_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	message_label.add_theme_constant_override("shadow_offset_x", 4)
	message_label.add_theme_constant_override("shadow_offset_y", 4)
	ui.add_child(message_label)
	combo_label = Label.new()
	combo_label.position = Vector2(1040, 156)
	combo_label.size = Vector2(220, 145)
	combo_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	combo_label.add_theme_font_size_override("font_size", 56)
	combo_label.add_theme_color_override("font_color", Color(1.0, 0.37, 0.06))
	combo_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	combo_label.add_theme_constant_override("shadow_offset_x", 4)
	combo_label.add_theme_constant_override("shadow_offset_y", 4)
	ui.add_child(combo_label)
	bottom_label = Label.new()
	bottom_label.position = Vector2(20, 674)
	bottom_label.size = Vector2(1240, 42)
	bottom_label.add_theme_font_size_override("font_size", 22)
	bottom_label.add_theme_color_override("font_color", Color(1.0, 0.87, 0.48))
	bottom_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	bottom_label.add_theme_constant_override("shadow_offset_x", 2)
	bottom_label.add_theme_constant_override("shadow_offset_y", 2)
	ui.add_child(bottom_label)

func _show_character_select():
	state = "select"
	background.visible = false
	title_screen.visible = true
	message_label.text = "GODS OF OLYMPUS\nSELECT HERO"
	enemy_label.text = ""
	combo_label.text = ""
	bottom_label.text = "1 PERSEUS  |  2 ATHENA  |  3 HERCULES  |  4 ARTEMIS     J = ATTACK   K = GOD POWER"
	_clear_select_cards()
	for i in range(4):
		var card := ColorRect.new()
		card.color = Color(0.0, 0.0, 0.0, 0.62)
		card.position = Vector2(122 + i * 280, 415)
		card.size = Vector2(205, 150)
		ui.add_child(card)
		select_cards.append(card)
		var portrait := TextureRect.new()
		portrait.position = card.position + Vector2(12, 20)
		portrait.size = Vector2(66, 96)
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		portrait.texture = load(heroes[i]["sprite"])
		ui.add_child(portrait)
		select_cards.append(portrait)
		var label := Label.new()
		label.position = card.position + Vector2(82, 16)
		label.size = Vector2(112, 120)
		label.add_theme_font_size_override("font_size", 18)
		label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.55))
		label.text = "%dP\n%s\n%s\nHP %d\nDMG %d" % [i + 1, heroes[i]["name"].to_upper(), heroes[i]["god"], heroes[i]["health"], heroes[i]["damage"]]
		ui.add_child(label)
		select_cards.append(label)
	_update_arcade_ui()

func _start_run(hero_index:int):
	chosen_hero = hero_index
	_clear_world()
	_clear_select_cards()
	background.visible = true
	title_screen.visible = false
	stage = 1
	gold = 0
	score = 0
	combo_hits = 0
	_spawn_player(heroes[hero_index])
	_start_stage()

func _spawn_player(data:Dictionary):
	player = PlayerScene.instantiate()
	player.position = Vector2(170, 560)
	player.hero_data = data
	player.died.connect(_on_player_died)
	player.hit_landed.connect(_on_hit_landed)
	add_child(player)

func _start_stage():
	state = "playing"
	message_label.text = "STAGE %d\n%s" % [stage, "HYDRA LAIR" if stage % 3 == 0 else "THE WILD WOODS"]
	enemies_left = 1 if stage % 3 == 0 else 5 + stage * 2
	_spawn_wave()

func _spawn_wave():
	var enemy_count = 1 if stage % 3 == 0 else min(enemies_left, 5)
	for i in range(enemy_count):
		var e = EnemyScene.instantiate()
		e.position = Vector2(rng.randi_range(760, 1210), rng.randi_range(390, 650))
		var max_index = min(enemy_types.size() - 1, 1 + int(stage / 2))
		var data = boss_type if stage % 3 == 0 else enemy_types[rng.randi_range(0, max_index)]
		e.configure(data, stage)
		e.killed.connect(_on_enemy_killed)
		e.damaged.connect(_on_enemy_damaged)
		add_child(e)
		enemies_left -= 1

func _on_enemy_killed(reward:int):
	gold += reward
	score += 80 + stage * 20 + combo_hits * 5
	_spawn_float("+%d GOLD" % reward, Vector2(rng.randi_range(570, 780), rng.randi_range(310, 420)), Color(1.0, 0.84, 0.16))
	if enemies_left > 0 and get_tree().get_nodes_in_group("enemies").size() < 4:
		_spawn_wave()

func _on_enemy_damaged(pos:Vector2, amount:int):
	_spawn_spark(pos, 1.0)
	_spawn_float(str(amount), pos + Vector2(10, -22), Color(1.0, 0.55, 0.18))

func _on_hit_landed(pos:Vector2, amount:int):
	combo_hits += 1
	combo_timer = 1.35
	_spawn_spark(pos, 1.1)

func _stage_clear():
	state = "upgrade"
	gold += stage * 12
	score += stage * 500
	_clear_upgrade_cards()
	_show_upgrades()

func _show_upgrades():
	var pool := [
		{"title":"BLESSING OF ARES", "desc":"+7 DAMAGE", "stat":"damage", "amount":7},
		{"title":"ARMOR OF ATHENA", "desc":"+32 MAX HP + HEAL", "stat":"health", "amount":32},
		{"title":"HERMES SANDALS", "desc":"+30 SPEED", "stat":"speed", "amount":30},
		{"title":"BRONZE OF HEPHAESTUS", "desc":"+2 DURABILITY", "stat":"durability", "amount":2},
		{"title":"NECTAR OF OLYMPUS", "desc":"HEAL 55 HP", "stat":"heal", "amount":55},
		{"title":"HEROIC RANK", "desc":"LEVEL UP", "stat":"level", "amount":1}
	]
	pool.shuffle()
	message_label.text = "STAGE %d CLEARED\nCHOOSE A BLESSING" % stage
	bottom_label.text = "Press 1, 2, or 3. More power now. Death still sends you back to the beginning."
	for i in range(3):
		var card = UpgradeCardScene.instantiate()
		card.position = Vector2(230 + i * 315, 300)
		card.option = pool[i]
		card.index = i + 1
		card.selected.connect(_apply_upgrade)
		add_child(card)

func _apply_upgrade(option:Dictionary):
	if player:
		player.apply_upgrade(option["stat"], int(option["amount"]))
	stage += 1
	_clear_upgrade_cards()
	_start_stage()

func _on_player_died():
	_clear_world()
	background.visible = false
	title_screen.visible = true
	state = "select"
	message_label.text = "YOU DIED\nRUN ERASED"
	enemy_label.text = "FINAL SCORE %d" % score
	combo_label.text = ""
	bottom_label.text = "Gold lost: %d. Press 1-4 to choose a hero and start again from Stage 1." % gold
	_clear_select_cards()

func _update_arcade_ui():
	for i in range(4):
		var h = heroes[i]
		var active = player != null and i == chosen_hero and state != "select"
		var hp_text = "%d/%d" % [player.health, player.max_health] if active else str(h["health"])
		var score_text := str(score) if active else "PRESS START"
		hero_labels[i].text = "%dP   %s\n%s\nHP %s  L%d\n%s" % [i + 1, str(h["name"]).to_upper(), score_text, hp_text, player.level if active else 1, "ACTIVE" if active else ""]
		hero_labels[i].modulate.a = 1.0 if active or state == "select" else 0.42
		hero_portraits[i].modulate.a = hero_labels[i].modulate.a
	if state == "playing":
		var strongest = _get_strongest_enemy()
		if strongest:
			enemy_label.text = "%s\nHP %d/%d" % [strongest.enemy_name.to_upper(), strongest.health, strongest.max_health]
		else:
			enemy_label.text = "CLEAR!"
		message_label.text = "STAGE %d\n%s" % [stage, "BOSS: HYDRA" if stage % 3 == 0 else "THE WILD WOODS"]
		combo_label.text = "%d\nHITS!" % combo_hits if combo_hits >= 2 else ""
		bottom_label.text = "GOLD %d     J ATTACK     K GOD POWER     ENEMIES LEFT %d     DIE ONCE = FULL RESTART" % [gold, enemies_left + get_tree().get_nodes_in_group("enemies").size()]

func _get_strongest_enemy():
	var strongest = null
	for e in get_tree().get_nodes_in_group("enemies"):
		if strongest == null or e.health > strongest.health:
			strongest = e
	return strongest

func _spawn_spark(pos:Vector2, scale_value:float):
	var spark := SparkScene.new()
	add_child(spark)
	spark.setup(pos, scale_value)

func _spawn_float(text_value:String, pos:Vector2, color_value:Color):
	var ft := FloatingTextScene.new()
	ui.add_child(ft)
	ft.setup(text_value, pos, color_value)

func _clear_upgrade_cards():
	for card in get_tree().get_nodes_in_group("upgrade_cards"):
		card.queue_free()

func _clear_select_cards():
	for n in select_cards:
		if is_instance_valid(n):
			n.queue_free()
	select_cards.clear()

func _clear_world():
	for n in get_children():
		if n != ui and n.name != "Background" and n.name != "TitleScreen":
			n.queue_free()
