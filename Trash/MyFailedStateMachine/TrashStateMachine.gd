#class_name StateMachine
extends Creature

export var initial_state := NodePath()
var state_list = []
onready var state = initial_state setget change_state
var previous_state


func _ready():
	for i in get_children():
		if i is State:
			state_list.append(i.state_name)
			i.connect("state_changed", self, "change_state")
			i.creature = self
			if self.stats != null:
				i.stats = self.stats
	
	if state == null:
		state = state_list[0]
		
func _process(delta):
	state._update(delta)
	
func _physics_process(delta):
	state._physics_update(delta)
		
func change_state(next_state):
	if has_node(next_state):
		state.exit()
		previous_state = state
		state = get_node(next_state)
		state.enter()
	
