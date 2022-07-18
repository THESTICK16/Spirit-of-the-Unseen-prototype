class_name NPC
extends Creature

var states = {
	"IDLE": 0,
	"WANDER": 1,
	"INTERACTING": 2
	}
	
var IDLE = states.get("IDLE")
var WANDER = states.get("WANDER")
var INTERACTING = states.get("INTERACTING")

signal state_changed

var state : int = IDLE setget change_state, get_state
var next_direction := Vector2.DOWN
var current_anim := "Down"

## If true, the NPC will not even turn to face other directions
export var stationary := false
## If true and stationary is false, the NPC will wander within a few steps of its starting position
export var wandering := false
## The distance at which the NPC can detect the player. Used to set when the NPC's speech bubble will pop up
export var player_detection_range := -1
## The filepath for the dialogue that this NPC will load when spoken to
export var dialogue_json_filepath : String
## The position at which the NPC starts
onready var start_position = global_position

onready var wander_timer = $WanderTimer
onready var animated_sprite = $AnimatedSprite
onready var detection_area = $DetectionArea
onready var speech_bubble := $ResizableSpeechBubble #$SpeechBubble

func _ready():
	if not is_in_group("NPCs"):
		add_to_group("NPCs")
	if wander_timer != null:
		wander_timer.connect("timeout", self, "change_direction")
	if detection_area != null:
		if player_detection_range >= 0:
			$DetectionArea/CollisionShape2D.shape.set_deferred("radius", player_detection_range)
		detection_area.connect("body_entered", self, "player_detected")
		detection_area.connect("body_exited", self, "player_undetected")
	
func _physics_process(delta):
	match state:
		IDLE:
			idle(delta)
		WANDER:
			wander(delta)

func idle(_delta):
	if animated_sprite.animation != "default":
		animated_sprite.play(current_anim)
	animated_sprite.stop()
	animated_sprite.frame = 0
	
func wander(_delta):
	if stationary:
		change_state(IDLE)
		return
		
	if is_on_wall():
		change_direction()
	
	velocity = move_and_slide(velocity)
	
func interacting():
	pass

## @Param new_state: an enumeration of the new state to be transitioned to
func change_state(new_state : int):
	state = new_state
	emit_signal("state_changed", new_state)
	
func get_state():
	return state
	
func add_state(state_name : String):
	var last_state := 0
	for i in states:
		if states.get(i) > last_state:
			last_state = states.get(i)
	states[state_name] = last_state + 1

func player_detected(_body):
	if speech_bubble != null:
		speech_bubble.show()
	
func player_undetected(_body):
	if speech_bubble != null:
		speech_bubble.hide()

func change_direction(next_dir : Vector2 = Vector2.ZERO):
	if stationary:
		return
	
	wander_timer.start(rand_range(1, 7))
	var next_rand = randi() % 5
	match next_rand:
		0: 
			next_direction = Vector2.UP
			if not wandering or get_state() == IDLE:
				current_anim = "Up"
		1: 
			next_direction = Vector2.DOWN
			if not wandering or get_state() == IDLE:
				current_anim = "Down"
		2: 
			next_direction = Vector2.LEFT
			if not wandering or get_state() == IDLE:
				current_anim = "Left"
		3: 
			next_direction = Vector2.RIGHT
			if not wandering or get_state() == IDLE:
				current_anim = "Right"
		4: 
			if get_state() == WANDER:
				change_state(IDLE)
				
func match_anim() -> String:
	match next_direction:
		Vector2.UP:
			return "Up"
		Vector2.DOWN:
			return "Down"
		Vector2.LEFT:
			return "Left"
		Vector2.RIGHT:
			return "Right"
	return current_anim

## @interface
## ALL INTERACTABLE SCENES MUST CONTAIN THIS METHOD!
## Returns the type of interaction that interacting with this object should have
## The return value should be a string of one of the player's states (maybe not, we'll see)
## Return type should be a constant from 'Interactables'
func get_interactable_type() -> String:
	return Interactables.DIALOGUE

## @interface
## ALL INTERACTABLE SCENES MUST CONTAIN THIS METHOD!
## Contains the logic for what happens when the player interacts with this object
func interact():
	DialogueLoader.create_dialogue_box(dialogue_json_filepath)
