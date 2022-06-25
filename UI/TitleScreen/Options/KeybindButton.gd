extends Button

## The input key that will be changed if this button is selected (i.e. "ui_left")
var key
## The value of the input that is mapped to the key
var value

## Emitted when the keybinding has changed
signal keybinding_changed(key, new_value)

## Whether the button is pressed and waiting for the player to enter its new value
var waiting_input := false

func _unhandled_input(event):
	if waiting_input:
		if event is InputEventKey:
			change_keybind_button(event.scancode)
#			value = event.scancode
#			text = OS.get_scancode_string(value)
#			pressed = false
#			waiting_input = false
		if event is InputEventMouseButton:
			text = OS.get_scancode_string(value)
			pressed = false
			waiting_input = false

func _toggled(button_pressed):
	if button_pressed:
		waiting_input = true
		set_text("Press Any Key")
		
func change_keybind_button(new_value):
		value = new_value
		if value != null:
			text = OS.get_scancode_string(value)
		else:
			text = "Unassigned"
			
		emit_signal("keybinding_changed", key, value)
		
		pressed = false
		waiting_input = false
