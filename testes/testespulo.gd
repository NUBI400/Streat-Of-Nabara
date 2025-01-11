extends CharacterBody2D
 
var MAX_SPEED = 100
var ACCELERATION = 500
var JUMP_SPEED = 25
var GRAVITY = 5
 
 
var z = 0
 
var jumpMultiplyer = 8
 
var Jumping = false
 
func _physics_process(delta):
	var axis = get_input_axis()
	print(Jumping)
	#if axis == Vector2.ZERO:
#		if  Jumping == false:
#			$AnimationPlayer.play("Idle")
		#apply_friction(ACCELERATION * delta)
	#else:
#		if  Jumping == false:
#			$AnimationPlayer.play("Run")
		#apply_movement(axis * ACCELERATION * delta)
		#
	#if global_position.y < 129.693 and Jumping == false:
		#velocity.y = 0
		#if axis.y > 0:
			#apply_movement(axis * ACCELERATION * delta)
		
	if Input.is_action_just_pressed("Pulo") and Jumping == false:
#		$AnimationPlayer.play("Jump")
		Jumping = true
		z += -JUMP_SPEED * jumpMultiplyer
		
	if z > 25 * jumpMultiplyer:
		Jumping = false
		z = 0
		velocity.y = 0
		
		
	if Jumping == true:
		z += GRAVITY
		velocity.y = z
	
	move_and_slide()
	
	
 
func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if axis.x > 0:
		$Sprite2D.flip_h = false
	elif axis.x < 0:
		$Sprite2D.flip_h = true
	
	return axis.normalized()
	
func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
 
func apply_movement(accel):
	velocity += accel
	velocity = velocity.clamp(accel, MAX_SPEED)
