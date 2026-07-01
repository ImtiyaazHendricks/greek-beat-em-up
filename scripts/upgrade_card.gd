extends Control
signal selected(option:Dictionary)

var option := {}
var index := 1

func _ready():
	add_to_group("upgrade_cards")
	custom_minimum_size = Vector2(250, 170)
	size = custom_minimum_size
	var panel := Panel.new()
	panel.size = custom_minimum_size
	add_child(panel)
	var title := Label.new()
	title.position = Vector2(16, 18)
	title.size = Vector2(220, 44)
	title.add_theme_font_size_override("font_size", 21)
	title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.38))
	title.text = "%d. %s" % [index, option["title"]]
	add_child(title)
	var desc := Label.new()
	desc.position = Vector2(16, 82)
	desc.size = Vector2(220, 70)
	desc.add_theme_font_size_override("font_size", 19)
	desc.add_theme_color_override("font_color", Color(0.82, 0.9, 1.0))
	desc.text = option["desc"]
	add_child(desc)

func _process(_delta):
	if Input.is_action_just_pressed("select_%d" % index):
		selected.emit(option)
