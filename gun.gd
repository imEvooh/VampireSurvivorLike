extends Area2D

func _physics_process(_delta):
	var ennemies_in_range = get_overlapping_bodies();
	var direction = Vector2.RIGHT.rotated(rotation);
	
	%Pistol.flip_v = false if direction.x > 0.0 else true;
	if ennemies_in_range.size() > 0:
		var target = null
		var closest_distance = $CollisionShape2D.shape.radius;

		for enemy in ennemies_in_range:
			var distance = global_position.distance_to(enemy.global_position);

			if distance < closest_distance:
				closest_distance = distance;
				target = enemy;

		if target:
			look_at(target.global_position);

func shoot():
	const BULLET = preload("res://bullet.tscn");
	var new_bullet = BULLET.instantiate();
	
	new_bullet.global_transform = %ShootingPoint.global_transform;
	%ShootingPoint.add_child(new_bullet);

func _on_timer_timeout():
	shoot();
