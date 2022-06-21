extends Node
class_name ControllerButtons

## Constants for the buttons to which an item can be assigned
## Only these should be used when changing equipment
const A = 'a'
const B = 'b'
const X = 'x'
const Y = 'y'
const L = 'l'
const R = 'r'
const ZL = 'zl'
const ZR = 'zr'
const START = '+'
const SELECT = '-'
## The buttons to which items can be equipped
const EQUIPPABLE_BUTTONS = [A, B, X, Y]

static func get_equippable_buttons():
	return EQUIPPABLE_BUTTONS
	
static func is_equippable_button(button: String):
	if not EQUIPPABLE_BUTTONS.has(button):
		print(button + "is not an equippable button")
		return false
		
	return true
