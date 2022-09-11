class_name Calculations
extends Node

static func calc_knockback(direction : Vector2, force : int, weight : int) -> Vector2:
	return Vector2.ZERO

#static func fix_to_4_way_direction(direction): #This function has yet to be thoroughly tested!!!
#	if direction.x != 0 and direction.y != 0:
#		if direction == Vector2(1,1).normalized() or direction == Vector2(1,1):
#			return Vector2.DOWN
#		if direction == Vector2(-1,1).normalized() or direction == Vector2(-1,1):
#			return Vector2.DOWN
#		if direction == Vector2(1,-1).normalized() or direction == Vector2(1,-1):
#			return Vector2.UP
#		if direction == Vector2(-1,-1).normalized() or direction == Vector2(-1,-1):
#			return Vector2.UP
#	else:
#		return direction

## Takes a Vector2 of any size and returns a Vector2 of the Vector2 type UP, DOWN, LEFT, RIGHT, or ZERO
## Calculates based on the largest absolute value of either direction's x or y value
## If x and y are equal and non-zero, the default return value will be DOWN
## @param the Vector2 to be turned into a directional Vector2
## @param a Vector2 of the Vector2 type UP, DOWN, LEFT, RIGHT, or ZERO. Based on direction's most prominent value
static func make_vector_directional(direction : Vector2) -> Vector2:
	var fixed_direction : Vector2	
	
	var x_is_greater := abs(direction.x) > abs(direction.y) #set to true if abs(x) is greater than abs(y) and false if vice versa
	var greater_value : float = direction.x if x_is_greater else direction.y
	
	if direction == Vector2.ZERO:
		fixed_direction = Vector2.ZERO
	elif direction.x == direction.y:
		fixed_direction = Vector2.DOWN
	elif x_is_greater:
		fixed_direction = Vector2(sign(greater_value), 0)
	elif not x_is_greater:
		fixed_direction = Vector2(0, sign(greater_value))
	
	return fixed_direction
		
#	elif greater_value > 0:
#		if x_is_greater:
#			fixed_direction = Vector2.RIGHT
#
#	elif x_is_greater:
#		if direction.x > 0:
#			fixed_direction = Vector2.RIGHT
#		elif direction.x < 0:
#			fixed_direction = Vector2.LEFT
#	elif not x_is_greater:
#		if direction.y < 0:
#			fixed_direction = Vector2.DOWN
