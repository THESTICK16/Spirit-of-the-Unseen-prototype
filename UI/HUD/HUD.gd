extends CanvasLayer

onready var player_stats = PlayerStats
onready var equipped_items = EquippedItems
onready var a_button = $HUDButtonLayout/AHUDButton #$AButton
onready var b_button = $HUDButtonLayout/BHUDButton #$BButton
onready var x_button = $HUDButtonLayout/XHUDButton #$XButton
onready var y_button = $HUDButtonLayout/YHUDButton #$YButton
onready var buttons = {ControllerButtons.A : a_button, ControllerButtons.B : b_button, ControllerButtons.X : x_button, ControllerButtons.Y: y_button}
#onready var hp_gauge = $HpGauge
onready var hp_meter = $HUDStatMeters/HealthMeter
onready var spirit_meter = $HUDStatMeters/SpiritMeter
#Make the health bar and buttons part of their own separate scenes with images instead of text

func _ready():
	player_stats.connect("health_changed", self, "set_hp_meter")
	player_stats.connect("spirit_energy_changed", self, "set_spirit_meter")
#	equipped_items.connect("equipped_items_changed", self, "update_equipped_icons")
	equipped_items.connect("button_equipped_changed", self, "set_button")
#	hp_gauge.bbcode_text = "Health: " + str(player_stats.health)
	set_hp_meter(player_stats.health)
	set_spirit_meter(player_stats.spirit_energy)
	set_buttons_to_equipped_items()
	
	yield()
	for i in buttons:
		buttons.get(i).set_hud_button(equipped_items.get_equipped_item_resource(i))
#	update_equipped_icons()

#func set_a_button(change_to): 
#	a_button.set_hud_button(change_to) #bbcode_text = str(change_to)
#	print(change_to) #FIXME!
#
#func set_b_button(change_to): 
##	if change_to.weapon_name != null:
##		b_button.bbcode_text = change_to.weapon_name
##	else:
#	b_button.set_hud_button(change_to) #bbcode_text = str(change_to)
#	print(change_to) #FIXME!
#
#func set_x_button(change_to): 
#	x_button.set_hud_button(change_to) #bbcode_text = str(change_to)
#	print(change_to) #FIXME!
#
#func set_y_button(change_to): 
#	y_button.set_hud_button(change_to) #bbcode_text = str(change_to)
#	print(change_to) #FIXME!
	
## changes the icon of the given button to the given image/text
## @param change_to the Texture (image) or text to change the icon to
## @param button the button of the icon to change
func set_button(button : String, change_to):
	if not ControllerButtons.is_equippable_button(button): #ControllerButtons.EQUIPPABLE_BUTTONS.has(button):
#		print(button + " is not an equippable button")
		return
	var button_icon : HUDButton = buttons.get(button)
	if change_to is Texture or change_to is String:
		button_icon.set_hud_button(change_to)
#	elif change_to is ConsumableItem:
#		button_icon.set_hud_button(change_to.get_item_field(Item.TEXTURE))
#		button_icon.set_stock_label(change_to.get_item_field(ConsumableItem.CURRENT_STOCK))
	elif change_to is Item:# and change_to.get_item_field(Item.PLAYER_HAS_ITEM):
		button_icon.set_hud_button(change_to.get_item_field(Item.TEXTURE))
		if change_to is ConsumableItem:
			button_icon.connect_stock_label(change_to) #change_to.connect("stock_changed", button_icon, "set_stock_label")
			return
	button_icon.set_stock_label(-1)
	
func set_hp_meter(change_to : int): 
#	hp_gauge.bbcode_text = "Health: " + str(change_to)
	hp_meter.value = change_to
	
func set_spirit_meter(change_to : int):
	spirit_meter.value = change_to
	
func set_buttons_to_equipped_items():
	var equipped_items_copy: Dictionary = equipped_items.get_equipped_items_copy()
	for button in equipped_items_copy:
		set_button(button, equipped_items_copy.get(button))
	
#func update_equipped_icons(): #FIXME change to properly update icons to images
#	set_a_button(equipped_items.get_equipped_item_field("a", Item.TEXTURE)) #equipped_items.get_equipped_item("a").get_item_field(Item.TEXTURE))
#	set_b_button(equipped_items.get_equipped_item_field("b", Item.TEXTURE)) #.get_equipped_item("b").get_item_field(Item.TEXTURE))
#	set_x_button(equipped_items.get_equipped_item_field("x", Item.TEXTURE)) #.get_equipped_item("x").get_item_field(Item.TEXTURE))
#	set_y_button(equipped_items.get_equipped_item_field("y", Item.TEXTURE)) #.get_equipped_item("y").get_item_field(Item.TEXTURE))
