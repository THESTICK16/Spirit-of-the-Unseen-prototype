extends StaticBody2D

onready var hurtbox = $HurtBox
onready var animation_player = $AnimationPlayer

## The group that this switch should affect. This must correspond to the name of a grou and match exactly in spelling and case
export (String) var group_to_call

func _ready():
	hurtbox.connect("area_entered", self, "call_group")

func call_group(_area):
	animation_player.play("rotate")
	if group_to_call != null and get_tree().has_group(group_to_call):
		get_tree().call_group(group_to_call, "switch_struck")
