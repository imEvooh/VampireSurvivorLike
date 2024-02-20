extends CharacterBody2D

signal health_depleted;
var health = 100.0;

func _ready():
	$ProgressBar.value = health;

func play_animations():
	if (velocity.length() > 0):
		$HappyBoo.play_walk_animation();
	else:
		$HappyBoo.play_idle_animation();

func _physics_process(delta):
	const DAMAGE_RATE = 50.0;
	var direction = Input.get_vector("move_left", "move_right",
									 "move_up", "move_down");
	var overlapping_monsters = $Hurtbox.get_overlapping_bodies();
	
	if (overlapping_monsters.size() > 0):
		health -= DAMAGE_RATE * overlapping_monsters.size() * delta;
		$ProgressBar.value = health;
		if (health <= 0.0):
			health_depleted.emit();
	velocity = direction * 600;
	$HappyBoo.scale.x = 1 if direction.x == 1 else -1;
	move_and_slide();
	play_animations();
