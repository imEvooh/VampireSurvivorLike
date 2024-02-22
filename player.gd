extends CharacterBody2D

signal health_depleted;
signal update_progress(value: float);

#Player stats
@export var max_health = 100.0;
@export var health = 100.0;
var player_level = 1;
var experience = 0;
var experience_required;

func _ready():
	%HealthBar.value = health;
	%LevelText.text = "Niv: " + str(player_level);
	experience_required = get_required_experience(player_level + 1);

func play_animations():
	if (velocity.length() > 0):
		%HappyBoo.play_walk_animation();
	else:
		%HappyBoo.play_idle_animation();

func taking_damage(delta):
	const DAMAGE_RATE = 50.0;
	var overlapping_monsters = %Hurtbox.get_overlapping_bodies();
	
	if (overlapping_monsters.size() > 0):
		health -= DAMAGE_RATE * overlapping_monsters.size() * delta;
		%HealthBar.value = health;
		if (health <= 0.0):
			health_depleted.emit();

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right",
									 "move_up", "move_down");
	
	taking_damage(delta);
	velocity = direction * 600;
	%HappyBoo.scale.x = 1 if direction.x == 1 else -1;
	move_and_slide();
	play_animations();

func get_required_experience(level):
	return round(pow(level, 1.85) + level * 4);

func _on_grab_area_entered(area):
	if (area.is_in_group("Loot")):
		area.target = self;

func level_up():
	player_level += 1;
	experience_required = get_required_experience(player_level + 1);
	health = max_health;
	%HealthBar.value = health;
	%LevelText.text = "Niv: " + str(player_level);	
	return experience / experience_required * 100;
	
func _on_collect_area_entered(area):
	if (area.is_in_group("Loot")):
		var expe = area.collect();
		var progress_value;
		
		experience += expe;
		progress_value = experience / experience_required * 100;
		if (experience >= experience_required):
			experience -= experience_required;
			progress_value = level_up();
		emit_signal("update_progress", progress_value);
