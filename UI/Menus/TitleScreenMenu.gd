extends Control
class_name TitleScreenMenu

signal new_displayed_menu(set_to)

func set_new_displayed_menu(set_to):
	emit_signal("new_displayed_menu", set_to)
