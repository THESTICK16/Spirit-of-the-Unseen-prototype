extends Panel
class_name HUDButton

onready var item_texture_rect : TextureRect = $CenterContainer/ButtonTextureRect/ItemTextureRect
onready var text_label : Label = $CenterContainer/ButtonTextureRect/TextLabel
onready var stock_label = $StockLabel

### The button to which this slot belongs
### Must match one of ControllerButtons.equippable_buttons
#export var button := ''

## The resource for the item that is being displayed
var item_resource : Item
## True if text is being shown, False if the image is being shown
var showing_text := false
	
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
	else:
		stock_label.show()
	stock_label.text = str(set_to)
	
func connect_stock_label(connect_to : ConsumableItem):
	if not connect_to.is_connected("stock_changed", self, "set_stock_label"):
#		call_deferred("set_stock_label", connect_to.get_item_field(ConsumableItem.CURRENT_STOCK))
		connect_to.connect("stock_changed", self, "set_stock_label")
		print("Connected") #FIXME!
	print(connect_to.get_item_field(ConsumableItem.CURRENT_STOCK)) #FIXME!
	set_stock_label(connect_to.get_item_field(ConsumableItem.CURRENT_STOCK))
