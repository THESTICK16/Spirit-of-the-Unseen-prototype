class_name Calculations
extends Node

static func calc_knockback(direction : Vector2, force : int, weight : int) -> Vector2:
	return Vector2.ZERO

static func fix_to_4_way_direction(direction): #This function has yet to be thoroughly tested!!!
	if direction.x != 0 and direction.y != 0:
		if direction == Vector2(1,1).normalized() or direction == Vector2(1,1):
			return Vector2.DOWN
		if direction == Vector2(-1,1).normalized() or direction == Vector2(-1,1):
			return Vector2.DOWN
		if direction == Vector2(1,-1).normalized() or direction == Vector2(1,-1):
			return Vector2.UP
		if direction == Vector2(-1,-1).normalized() or direction == Vector2(-1,-1):
			return Vector2.UP
	else:
		return direction
		
