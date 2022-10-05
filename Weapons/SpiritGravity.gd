extends KinematicWeapon

## The degree to which the gravity pulls those caught in its field
const max_pull_strength := 700
## The rate at which a caught enemy approaches max_pull_strength
const pull_acceleration := 150

## An array containg the enemies caught in the range of the gravity field
#var caught_enemies := []
## The enemy currently captured by the gravity field
var caught_enemy : Enemy = null

onready var despawn_timer = $DespawnTimer
onready var enemy_detection_area = $EnemyDetectionArea

func _ready():
	if despawn_timer != null:
		despawn_timer.connect("timeout", self, "queue_free")
	if enemy_detection_area != null:
		enemy_detection_area.connect("body_entered", self, "catch_enemy")
		enemy_detection_area.connect("body_exited", self, "release_enemy")
	

func _physics_process(delta):
	if not is_instance_valid(caught_enemy):
		release_enemy(caught_enemy)
	if caught_enemy == null:
		var enemies_in_field = enemy_detection_area.get_overlapping_bodies()
		if enemies_in_field.size() > 0:
			catch_enemy(enemies_in_field[0])
	
	pull(delta)

func catch_enemy(enemy: Enemy):
	if enemy is Enemy:
		if caught_enemy == null:
			caught_enemy = enemy
#		caught_enemies.append(enemy)
	
func release_enemy(enemy: Enemy):
	caught_enemy = null
#	if caught_enemies.has(enemy):
#		caught_enemies.erase(enemy)
		
## Pulls the caught_enemy toward the center of the gravity circle
## @param delta the delta time variable
func pull(delta):
	if is_instance_valid(caught_enemy):
		caught_enemy.global_position =  caught_enemy.global_position.move_toward(caught_enemy.global_position.direction_to(global_position) * max_pull_strength, pull_acceleration * delta)
	
	else: release_enemy(caught_enemy)
	
	
#	for enemy in caught_enemies:
#		if is_instance_valid(enemy):
#			enemy.call_deferred("move_and_slide", (enemy.global_position.direction_to(global_position) * max_pull_strength * delta)) #.move_and_slide(enemy.global_position.direction_to(global_position) * max_pull_strength * delta)
#			enemy.global_position = enemy.global_position.move_toward(enemy.global_position.direction_to(global_position) * max_pull_strength, pull_acceleration * delta)
#			if enemy.get("velocity") != null:
#				var pull_direction = enemy.global_position.direction_to(global_position)
#				enemy.velocity = enemy.velocity.move_toward(pull_direction * max_pull_strength, pull_acceleration * delta)
#		else:
#			release_enemy(enemy)
