extends TitleScreenMenu

onready var scroll_container = $ScrollContainer

const SCROLL_SPEED := 100

func _process(delta):
	var vertical_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if vertical_input != 0:
		scroll_container.scroll_vertical += (vertical_input * 2) * SCROLL_SPEED * delta
	else:
		scroll_container.scroll_vertical += SCROLL_SPEED * delta
