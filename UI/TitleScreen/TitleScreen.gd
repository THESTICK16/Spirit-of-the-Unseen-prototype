extends CanvasLayer

onready var menus = $Menus
onready var main_menu = $Menus/MainMenu
onready var continue_menu = $Menus/ContinuePlaceHolder
onready var options_menu = $Menus/OptionsMenu
onready var off_screen_position : Vector2 = $OffScreenSetPosition2D.global_position

## The menu that is displayed and being interacted with
var displayed_menu : TitleScreenMenu setget set_displayed_menu
## The previously displayed menu, which should be accessed by pressing back
var previous_menu : TitleScreenMenu
## The position at which displayed_menu should be set
var display_position : Vector2 = Vector2.ZERO

func _ready():
	for menu in menus.get_children():
		menu.connect("new_displayed_menu", self, "swap_menus_from_string")
	
	continue_menu.set_global_position(off_screen_position)
	options_menu.set_global_position(off_screen_position)
	self.displayed_menu = main_menu
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("b"):
		self.displayed_menu = main_menu #Fix this so it goes back one layer at a time (only if relevant)

func set_displayed_menu(set_to : TitleScreenMenu):
	if set_to == null:
		return
	
	if displayed_menu != null:
		previous_menu = displayed_menu
		previous_menu.set_global_position(off_screen_position)
	
	displayed_menu = set_to
	displayed_menu.set_global_position(display_position)
	displayed_menu.grab_focus() #Apparently this can't grab focus? Make sure everything works properly
	
func swap_menus_from_string(swap_to : String):
	var new_displayed = menus.get_node(swap_to)
	if new_displayed == null:
		print("There is no menu called " + swap_to)
		return
		
	self.displayed_menu = new_displayed
