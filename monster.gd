extends CharacterBody2D

var health = 10;
var player;

func _ready():
	player = get_node("/root/Game/Player");
	$Slime.play_walk();
	$ProgressBar.max_value = health;
	$ProgressBar.value = health;

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position);
	
	velocity = direction * 300;
	move_and_slide();

func take_damage(damage):
	health -= damage;
	$ProgressBar.value = health;
	$Slime.play_hurt();
	if (health <= 0):
		queue_free();
		pop_exp();
		display_smoke();

func pop_exp():
	const EXP_GEM = preload("res://experience_gem.tscn");
	var gem = EXP_GEM.instantiate();
	
	get_parent().call_deferred("add_child", gem);
	gem.global_position = global_position;

func display_smoke():
	const SMOKE_EXPLOSION = preload("res://smoke_explosion/smoke_explosion.tscn")
	var smoke = SMOKE_EXPLOSION.instantiate();
	
	get_parent().add_child(smoke);
	smoke.global_position = global_position;
