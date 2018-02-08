extends KinematicBody2D

export var MOTION_SPEED = 140
const IDLE_SPEED = 10
onready var sprite = get_node("AnimatedSprite")
var RayNode 
var PlayerAnimNode
var anim = ""
var animNew = ""

# Converts any Vector2 coordinates or motion from the cartesian to the isometric system
func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)


# useful to convert mouse coordinates back to screen-space, and detect where the player wants to know.
# If we want to add mouse-based controls, we'll need this function
func isometric_to_cartesian(iso):
	var cart_pos = Vector2()
	cart_pos.x = (iso.x + iso.y * 2) / 2
	cart_pos.y = - iso.x + cart_pos.x
	return cart_pos


func _ready():
	set_fixed_process(true)
	
	RayNode = get_node("RayCast2D")
	PlayerAnimNode = get_node("AnimatedSprite")
	
func _fixed_process(delta):
	var motion = Vector2()
	
	#motion
	if (Input.is_action_pressed("ui_up")):
		motion = Vector2(0, -1)
		RayNode.set_rotd(180)
		
	if (Input.is_action_pressed("ui_down")):
		motion = Vector2(0, 1)
		RayNode.set_rotd(0)
		
	if (Input.is_action_pressed("ui_left")):
		motion = Vector2(-1, 0)
		RayNode.set_rotd(-90)
		
	if (Input.is_action_pressed("ui_right")):
		motion = Vector2(1, 0)
		RayNode.set_rotd(90)
		
	motion = motion.normalized()*MOTION_SPEED*delta
# Isometric movement is movement like you're used to, converted to the isometric system
	motion = cartesian_to_isometric(motion)
	move(motion)
	
	var slide_attempts = 4
	while(is_colliding() and slide_attempts > 0):
		motion = get_collision_normal().slide(motion)
		motion = move(motion)
		slide_attempts -= 1
		
	#animation
	if (motion.length() > IDLE_SPEED*0.09):
		if (Input.is_action_pressed("ui_up")):
			anim = "Up"
		if (Input.is_action_pressed("ui_down")):
			anim = "Down"
		if (Input.is_action_pressed("ui_left")):
			anim = "Sideways"
			sprite.set_flip_h(true)
		if (Input.is_action_pressed("ui_right")):
			anim = "Sideways"
			sprite.set_flip_h(false)

	if anim != animNew:
		animNew = anim
		PlayerAnimNode.play(anim)