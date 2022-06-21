extends State

var velocity 
var direction
var knockback

func _ready():
	yield(owner, "ready")
	velocity = creature.velocity
	direction = creature.direction
	knockback = creature.knockback

func _physics_update(delta):
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if velocity != Vector2.ZERO:
		direction = velocity.normalized()
	
	
	creature.move_and_slide((velocity.normalized() * stats.max_speed))
