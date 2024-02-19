extends Area2D

var travelled_distance = 0;
const speed = 1000;
const maxRange = 1200;

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation);
	
	position += direction * speed * delta;
	travelled_distance += speed * delta;
	if (travelled_distance > maxRange):
		queue_free();


func _on_body_entered(body):
	queue_free();
	if (body.has_method("take_damage")):
		body.take_damage(5);
