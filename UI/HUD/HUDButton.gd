extends Panel
class_name HUDButton

onready var item_texture_rect : TextureRect = $CenterContainer/ButtonTextureRect/ItemTextureRect
onready var text_label : Label = $CenterContainer/ButtonTextureRect/TextLabel
onready var stock_label = $StockLabel
onready var null_texture = preload("res://Assets/BlankImage.png")
onready var bow_texture = preload("res://Assets/BowIcon.png")
onready var button_letter = get_button_letter()
onready var button_texture_rect = $CenterContainer/ButtonTextureRect

### The button to which this slot belongs
### Must match one of ControllerButtons.equippable_buttons
#export var button := ''

## The resource for the item that is being displayed
var item_resource : Item
## True if text is being shown, False if the image is being shown
var showing_text := false

func _input(event):
	if Input.is_action_pressed(button_letter):
		button_texture_rect.set("modulate", Color.lightskyblue)
	elif Input.is_action_just_released(button_letter):
		button_texture_rect.set("modulate", Color.white)
	else:
		button_texture_rect.set("modulate", Color.white)

func set_hud_button(change_to):
	if change_to is String and change_to == "":
		_show_image()
	elif change_to is String:
		_set_text(change_to)
		_show_text()
	elif change_to is Texture:
		_set_item_image(change_to)
		_show_image()

func _set_item_image(image):
	item_texture_rect.texture = image

func _set_text(text):
	text_label.text = text

func _show_text():
	showing_text = true
	item_texture_rect.hide()
	text_label.show()

func _show_image():
	showing_text = false
	text_label.hide()
	item_texture_rect.show()

func _swap_displayed():
	if showing_text:
		_show_image()
	elif not showing_text:
		_show_text()

func set_stock_label(set_to: int):
	if set_to < 0:
		stock_label.hide()
	elif item_texture_rect.texture != bow_texture: #This is a temporary fix for the bug that displays the stock label on any button icon that the bow was previously equipped to fix this
		stock_label.hide()
		push_warning("The button is checking to see if the bow is equipped to display the stock label. FIX THIS FOR FUTURE RELEASES")
	else:
		stock_label.show()
	stock_label.text = str(set_to)
	
func connect_stock_label(connect_to : ConsumableItem):
	if not connect_to.is_connected("stock_changed", self, "set_stock_label"):
#		call_deferred("set_stock_label", connect_to.get_item_field(ConsumableItem.CURRENT_STOCK))
		connect_to.connect("stock_changed", self, "set_stock_label")
	call_deferred("set_stock_label", connect_to.get_item_field(ConsumableItem.CURRENT_STOCK))
#	set_stock_label(connect_to.get_item_field(ConsumableItem.CURRENT_STOCK))

func get_button_letter() -> String:
	var button_letter = "?"
	
	var first_letter = name[0].to_lower()
	if ControllerButtons.is_equippable_button(first_letter):
		button_letter = first_letter
	
	print(button_letter)
	return button_letter
