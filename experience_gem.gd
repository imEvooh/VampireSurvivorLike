extends Area2D

@export var experience = 1;

var target : CharacterBody2D = null;
var speed = -1;

#Sprites preload
var green_gem = preload("res://experience_gems/Gem_green.png");
var blue_gem = preload("res://experience_gems/Gem_blue.png");
var red_gem = preload("res://experience_gems/Gem_red.png");

func _ready():
	if (is_value_between(experience, 5, 24)):
		$Sprite.texture = blue_gem;
	elif (experience >= 25):
		$Sprite.texture = red_gem;

func _physics_process(delta):
	if (target != null):
		global_position = global_position.move_toward(target.global_position, speed);
		speed += 8 * delta;

func is_value_between(value: int, low_bound: int, upper_bound: int) -> bool:
	return value >= low_bound && value <= upper_bound;

func collect():
	$gem_collected.play();
	$CollisionShape2D.call_deferred("set", "disabled", true);
	$Sprite.visible = false;
	return experience;

func _on_gem_collected_finished():
	queue_free();
