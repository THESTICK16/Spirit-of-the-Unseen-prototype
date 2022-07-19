extends CanvasLayer
## All menus in the 'menus' node must be of type Control and inherit from the script TitleScreenMenu for this to work properly


onready var menus = $Menus
onready var main_menu : TitleScreenMenu = menus.get_children()[0] #$Menus/MainMenu
#onready var continue_menu = $Menus/ContinuePlaceHolder
#onready var options_menu = $Menus/OptionsMenu
onready var off_screen_position : Vector2 = $OffScreenSetPosition2D.global_position

## The menu that is displayed and being interacted with
var displayed_menu : TitleScreenMenu setget set_displayed_menu
## The previously displayed menu, which should be accessed by pressing back
var previous_menu : TitleScreenMenu
## The position at which displayed_menu should be set
var display_position : Vector2 = Vector2.ZERO

signal menu_opened

signal menu_closed

func _ready():
	for menu in menus.get_children():
		menu.connect("new_displayed_menu", self, "swap_menus_from_string")
		menu.set_global_position(off_screen_position)
		menu.focus_mode = Control.FOCUS_NONE
	
	self.displayed_menu = main_menu
	
	emit_signal("menu_opened")
	
func _unhandled_input(_event):
	if PauseController.is_paused() and (Input.is_action_just_pressed("pause") or (Input.is_action_just_pressed("b") and displayed_menu == main_menu)):
		call_deferred("close_menu") 
	elif Input.is_action_just_pressed("b") and not PauseController.is_paused():
		self.displayed_menu = main_menu #Fix this so it goes back one layer at a time (only if relevant)
	

func set_displayed_menu(set_to : TitleScreenMenu):
	if set_to == null:
		return
	
	if displayed_menu != null:
		previous_menu = displayed_menu
		previous_menu.set_global_position(off_screen_position)
		previous_menu.focus_mode = Control.FOCUS_NONE
	
	displayed_menu = set_to
	displayed_menu.set_global_position(display_position)
	displayed_menu.focus_mode = Control.FOCUS_ALL
	displayed_menu.grab_focus() #Apparently this can't grab focus? Make sure everything works properly
	
func swap_menus_from_string(swap_to : String):
	var new_displayed = menus.get_node(swap_to)
	if new_displayed == null:
		print("There is no menu called " + swap_to)
		return
		
	self.displayed_menu = new_displayed
	
func close_menu():
	emit_signal("menu_closed")
	queue_free()
