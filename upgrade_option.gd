extends Button

var item = null;

signal selected_upgrade(upgrade);

func _ready():
	var player = get_tree().get_first_node_in_group("player");
	
	connect("selected_upgrade", Callable(player, "upgrade_player"));

func _on_pressed():
	emit_signal("selected_upgrade", item);
