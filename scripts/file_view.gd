extends Control

@onready var item_con := $VBox/Scroller/Items
@onready var item_tscn := preload("res://scenes/item.tscn")

var v := 0
var v_reset := 30
var v_weight := 0.1


func _process(delta):
	$VBox/Scroller/Items.position.y += v
	v = lerp(v, 0, v_weight * delta)
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$VBox/Scroller/Scroll_bar.value = abs($VBox/Scroller/Items.position.y)
	
	if $VBox/Scroller/Items.position.y > 0:
		$VBox/Scroller/Items.position.y = 0
	
	if $VBox/Scroller/Items.position.y < -($VBox/Scroller/Items.size.y - $VBox/Scroller.size.y):
		$VBox/Scroller/Items.position.y = -($VBox/Scroller/Items.size.y - $VBox/Scroller.size.y)
	
	
	$VBox/Scroller/Items.columns = int(DisplayServer.window_get_size().x / 350.0)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			v = v_reset
		
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			v = -v_reset


func get_random_pass(lenght : int = randi_range(10, 20)):
	var password := ""
	for i in range(lenght):
		password += Files.valid_char[randi_range(0, len(Files.valid_char) - 1)]
	return password


func add_item(url : String, username : String, password : String, as_new := true):
	var new = item_tscn.instantiate()
	new.set_variabels(url, username, password)
	if not as_new:
		new._on_lock_toggled(true)
		new.get_node("VBox/Topbar/Lock").button_pressed = true
	item_con.add_child(new)
	$VBox/Scroller/Items.position.y = -(($VBox/Scroller/Items.size.y - $VBox/Scroller.size.y) * 2)
	$VBox/Scroller/Scroll_bar.max_value = ($VBox/Scroller/Items.size.y - $VBox/Scroller.size.y)

func get_items():
	return $VBox/Scroller/Items.get_children()

func remove_all_items():
	for item in $VBox/Scroller/Items.get_children():
		$VBox/Scroller/Items.remove_child(item)


func _on_item_deleted():
	$VBox/Scroller/Scroll_bar.max_value = ($VBox/Scroller/Items.size.y - $VBox/Scroller.size.y)

func _on_new_item_pressed():
	item_con.add_child(item_tscn.instantiate())
	$VBox/Scroller/Items.position.y = -(($VBox/Scroller/Items.size.y - $VBox/Scroller.size.y) * 2)
	$VBox/Scroller/Scroll_bar.max_value = ($VBox/Scroller/Items.size.y - $VBox/Scroller.size.y)

func _on_scroll_bar_scrolling():
	$VBox/Scroller/Items.position.y = -$VBox/Scroller/Scroll_bar.value

func _on_scroller_resized():
	$VBox/Scroller/Items.anchors_preset = PRESET_FULL_RECT

func _on_save_pressed():
	get_parent().save()

func _on_back_pressed():
	get_parent().save()
	self.visible = false
	remove_all_items()
	get_parent().get_node("Login").visible = true

func _on_random_pressed():
	DisplayServer.clipboard_set(get_random_pass())
	get_parent().show_title("Copied", Color("#00D566"))
	await get_tree().create_timer(3).timeout
	get_parent().hide_title()
