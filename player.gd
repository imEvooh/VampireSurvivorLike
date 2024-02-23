extends CharacterBody2D

signal health_depleted;
signal update_progress(value: float);

const MAX_UPGRADE : int = 3;

#Player stats
@export var max_health = 100.0;
@export var health = 100.0;
var player_level = 1;
var experience = 0;
var experience_required;

#Upgrades GUI
@onready var level_panel = get_node("%Upgrades");
@onready var upgrades_opts = get_node("%UpgradesOptions");
@onready var levelup_sound = get_node("%LevelUpSound");

#Preload GUI opt
@onready var upgrade_option = preload("res://upgrade_option.tscn");

func _ready():
	var x_axis_player = get_viewport_rect().size.x / 2 + 250;
	var y_axis_player = get_viewport_rect().size.y / 2;
	
	global_position = Vector2(x_axis_player, y_axis_player);
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

func upgrade_player(upgrade):
	upgrades_opts.get_children().filter(func(child): child.queue_free());
	level_panel.visible = false;
	get_tree().paused = false;
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;

func display_upgrade_options():
	for n in MAX_UPGRADE:
		var option = upgrade_option.instantiate();
		
		print(option.item);
		upgrades_opts.add_child(option);

func display_upgrade_panel():
	var tween : Tween = level_panel.create_tween();
	var x_axis_panel : float = (get_viewport_rect().size.x / 2) - ($CanvasLayer/Control/Upgrades.size.x / 2);
	var y_axis_panel : float = (get_viewport_rect().size.y / 2) - ($CanvasLayer/Control/Upgrades.size.y / 2);
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	tween.tween_property(level_panel, "position", Vector2(x_axis_panel, y_axis_panel), 0.3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN);
	tween.play();
	level_panel.visible = true;
	display_upgrade_options();
	get_tree().paused = true;

func level_up():
	levelup_sound.play();
	player_level += 1;
	%LevelText.text = "Niv: " + str(player_level);
	experience_required = get_required_experience(player_level + 1);
	health = max_health;
	%HealthBar.value = health;
	display_upgrade_panel();
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
