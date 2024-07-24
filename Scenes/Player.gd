extends Area2D

@export var speed : int = 400; #pixels/sec movement of player
var screen_size : Vector2;
var velocity : Vector2;
signal hit;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide();
	screen_size = get_viewport_rect().size;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	velocity = Vector2.ZERO;
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1;
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1;
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1;
	if Input.is_action_pressed("move_down"):
		velocity.y += 1;
	
	# we moving?
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed;
		# $ is shorthand for get_node(). 
		$AnimatedSprite2D.play();
	else:
		$AnimatedSprite2D.stop();
	
	position += velocity * delta;
	position = position.clamp(Vector2.ZERO,screen_size);
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk";
		$AnimatedSprite2D.flip_v = false;
		$AnimatedSprite2D.flip_h = velocity.x < 0;
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up";
		$AnimatedSprite2D.flip_v = velocity.y > 0;
	
	
# end _process(delta) method


func _on_body_entered(body) -> void:
	hide();
	hit.emit();
	$CollisionShape2D.set_deferred("disabled",true);

func start(pos):
	position = pos;
	show();
	$CollisionShape2D.disabled = false;
