extends Node

@export var mob_scene: PackedScene;
var score: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass


func game_over() -> void:
	$BackGroundMusic.stop();
	$DeathSound.play();
	$HeadsUpDisplay.show_game_over();
	$ScoreTimer.stop();
	$MobTimer.stop();

func new_game() -> void:
	$BackGroundMusic.play();
	get_tree().call_group("mobs","queue_free");
	score = 0;
	$HeadsUpDisplay.update_score(score);
	$HeadsUpDisplay.show_message("Get Ready");
	$Player.start($StartPosition.position);
	$StartTimer.start();

func _on_start_timer_timeout() -> void:
	$MobTimer.start();
	$ScoreTimer.start();

func _on_score_timer_timeout() -> void:
	score += 1;
	$HeadsUpDisplay.update_score(score);


func _on_mob_timer_timeout() -> void:
	
	# Create a new instnace of mob scene
	var mob = mob_scene.instantiate();
	
	# Choose a random location on Path2D
	var mob_spawn_location = $Path2D/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf();
	
	# Mob direction is perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2;
	# randomize it a bit
	direction += randf_range(-PI / 4, PI / 4);
	
	mob.position = mob_spawn_location.position;
	mob.rotation = direction;
	
	var velocity = Vector2(randf_range(150.0,250.0),0.0);
	mob.linear_velocity = velocity.rotated(direction);
	
	add_child(mob);

func _on_heads_up_display_start_game():
	new_game();
