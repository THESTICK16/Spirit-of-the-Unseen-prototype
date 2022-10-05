class_name Player
extends Creature

	# Modified at runtime
#---------------------------------------------------------------------------------------
## The player's input direction, stored as a Vector2
var input_vector := Vector2.ZERO
## True if the player is dead
var is_dead := false
## Stores the object if an NPC or onject is interactable
var interactable_object
## If true, pressing 'A' will trigger an interaction with the interactable item, else will use equipped_item_a
var interacting := false
#onready var equipped_item_a = Boomerang # temporarily set to boomerang, in the end modified through the menu get rid of the onready
#onready var equipped_item_b = Sword # temporarily set to sword, in the end modified through the menu. get rid of the onready
#onready var equipped_item_x = Arrow # temporarily set to arrow, in the end modified through the menu. get rid of the onready
#onready var equipped_item_y = RotateAttack # temporarily set to RotateAttack, in the end modified through the menu. get rid of the onready
#---------------------------------------------------------------------------------------

	# Nodes and other external references
#---------------------------------------------------------------------------------------
onready var stats = PlayerStats
onready var equipment = Equipment
onready var equipped_items = EquippedItems
onready var animation_tree := $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var ranged_weapon_spawn_position := $RangedWeaponSpawnPosition
onready var hurtbox = $HurtBox
onready var state_machine = $StateMachine
onready var camera = $Camera2D
onready var sprite_center_position = $SpriteCenterPosition2D
onready var interactable_detection_area = $InteractableDetectionArea
onready var hud = $HUD
onready var walking_audio = $WalkingAudioStreamPlayer
onready var tilemap_detection_area = $TilemapDetectionBox
onready var tween = $Tween
onready var visibility_notifier = $VisibilityNotifier2D


#onready var inventory_menu = $Inventory
#---------------------------------------------------------------------------------------

#	# Items
##---------------------------------------------------------------------------------------
#var Boomerang = preload("res://Weapons/Boomerang.tscn")
#var Arrow = preload("res://Weapons/Arrow.tscn")
#var Sword  = preload("res://Weapons/Sword.tscn")
#var RotateAttack = preload("res://Weapons/RotateAttack.tscn")
#var SpiritBomb = preload("res://Weapons/SpiritBomb.tscn")
#onready var inventory = stats.inventory #{"Boomerang": Boomerang, "Arrow": Arrow, "Sword": Sword, "RotateAttack": RotateAttack}
##---------------------------------------------------------------------------------------

	# Variables for items
#---------------------------------------------------------------------------------------
var can_throw_boomerang := true
var can_fire_arrow := true
var can_use_spirit_attack := true
#---------------------------------------------------------------------------------------

	#Misc.
#---------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------

func _ready():
	PlayerStats.player = self
	if hurtbox != null:
		hurtbox.connect("area_entered", self, "take_hit")
	if interactable_detection_area != null:
		interactable_detection_area.connect("area_entered", self, "recognize_interactable")
		interactable_detection_area.connect("area_exited", self, "remove_interactable")
	if walking_audio != null:
		walking_audio.connect("finished", self, "vary_walking_pitch")
#	if tilemap_detection_area != null:
#		tilemap_detection_area.connect("area_entered", self, "scroll_camera")
	if stats.respawn_position != null and stats.respawn_position != Vector2.ZERO:
#		global_position = stats.respawn_position
		set_deferred("global_position", stats.respawn_position)
		camera.call_deferred("reset_smoothing")
	stats.last_scene_path = get_tree().current_scene.filename
	call_deferred("initialize_camera_limits")
	
	
	set_physics_process(false) #This is done because for some reason the state changes to scroll camera upon loading a new scene if the player is moving upon loading
	yield(get_tree().create_timer(0.45), "timeout")
	set_physics_process(true)
	
func _unhandled_input(_event):
	if Input.is_action_just_pressed("toggle_eyes"):
		stats.eyes_active = !stats.eyes_active

func _physics_process(_delta):
#	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", 0.5)
	input_vector = input_vector.round()
	
	
#func get_equipped_button(item: PackedScene):
#	match item:
#		stats.equipped_item_a:
#			return "a"
#		stats.equipped_item_b:
#			return "b"
#		stats.equipped_item_x:
#			return "x"
#		stats.equipped_item_y:
#			return "y"
#	return null
	
func take_hit(area):
	#put this function in the parent class ("Creature") so all creatures take hits with one code for easy changes
#	if area.stuns:
		#Put the player in a "stunned" state that makes them unable to move or anything for a set time
	stats.health -= area.damage
	if area.direction != null and area.direction != Vector2.ZERO: 
		velocity = area.direction * area.knockback
	else:
		velocity = area.global_position.direction_to(sprite_center_position.global_position) * area.knockback
	hurtbox.start_invincibility(invincibility_duration)
	if area.get_parent().has_method("give_hit"):
		area.get_parent().give_hit()
		
func recognize_interactable(area):
	if area.has_method("get_interactable_type") and area.has_method("interact"):
		interactable_object = area
	else:
		interactable_object = area.get_parent()
	interacting = true
	if interactable_object.has_method("get_interactable_type"):
		hud.set_button(ControllerButtons.A, Interactables.get_interactable_label_text(interactable_object.get_interactable_type()))
#		if interactable_object.get_interactable_type() == Interactables.DIALOGUE:
#			hud.set_button(ControllerButtons.A, "Talk")
	
func remove_interactable(_area):
	interactable_object = null
	interacting = false
	hud.set_button(ControllerButtons.A, "") #("A: Use Item")
	
func get_equipped_item(button : String):
	if not ControllerButtons.is_equippable_button(button):
		return equipment.NULLITEM
	
	return equipped_items.get_equipped_item_resource(button)
#	if button != "a" and button != "b" and button != "x" and button != "y":
#		return
#	return stats.get_equipped_item(button)

func vary_walking_pitch():
	walking_audio.pitch_scale = rand_range(0.8, 1.2)
	
func initialize_camera_limits():
	yield(get_tree().create_timer(.02), "timeout")
#	yield(TransitionController, "scene_changed")
	if tilemap_detection_area.get_overlapping_areas().size() > 0:
		camera.set_extents(tilemap_detection_area.get_overlapping_areas()[0].get_parent())
	
#func scroll_camera(_area):
#	if _area.get_parent() is TileMap:
#		var camera_size = get_viewport_rect().size
#
#		var new_limits : Dictionary = camera.get_new_extents(_area.get_parent())
#		for limit in new_limits:
#			tween.interpolate_property(camera, limit, camera.get(limit), new_limits.get(limit), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
#
#		tween.start()
##		yield(tween, "tween_all_completed")

func update_animation_tree_blend_positions():
	animation_tree.set("parameters/Idle/blend_position", PlayerStats.player.direction)
	animation_tree.set("parameters/Move/blend_position", PlayerStats.player.direction)
	animation_tree.set("parameters/Attack/blend_position", PlayerStats.player.direction)

