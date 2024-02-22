extends Node2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;

func spawn_monster():
	var new_monster = preload("res://monster.tscn").instantiate();
	
	%PathFollow2D.progress_ratio = randf();
	new_monster.global_position = %PathFollow2D.global_position;
	add_child(new_monster);

func _on_timer_timeout():
	spawn_monster();

func _on_player_health_depleted():
	%GameOver.visible = true;
	get_tree().paused = true;
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

func _on_restart_button_pressed():
	get_tree().paused = false;
	get_tree().reload_current_scene();


func _on_player_update_progress(new_value):
	%ProgressBar.value = new_value;
