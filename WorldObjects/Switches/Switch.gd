extends StaticBody2D

onready var hurtbox = $HurtBox
onready var animation_player = $AnimationPlayer

## The group that this switch should affect. This must correspond to the name of a grou and match exactly in spelling and case
export (String) var group_to_call

signal switch_struck

func _ready():
	hurtbox.connect("area_entered", self, "struck")

func struck(_area):
	if animation_player != null and animation_player.has_animation("struck"):
		animation_player.play("struck")
	if group_to_call != null and get_tree().has_group(group_to_call):
		get_tree().call_group(group_to_call, "switch_struck")
	
	emit_signal("switch_struck")
