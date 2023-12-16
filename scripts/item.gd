extends Panel


func set_variabels(url :String, username : String, password : String):
	$VBox/Website/Url_input.text = url
	$VBox/Username/Username_input.text = username
	$VBox/Password/Password_input.text = password

func get_variabels():
	return [
		$VBox/Website/Url_input.text,
		$VBox/Username/Username_input.text,
		$VBox/Password/Password_input.text
	]


func _on_lock_toggled(button_pressed):
	$VBox/Website/Url_input.editable = !button_pressed
	$VBox/Username/Username_input.editable = !button_pressed
	$VBox/Password/Password_input.editable = !button_pressed

func _on_website_copy_pressed():
	DisplayServer.clipboard_set($VBox/Website/Url_input.text)
	await get_tree().create_timer(5).timeout
	$VBox/Website/Copy.button_pressed = false

func _on_username_copy_pressed():
	DisplayServer.clipboard_set($VBox/Username/Username_input.text)
	await get_tree().create_timer(5).timeout
	$VBox/Username/Copy.button_pressed = false

func _on_show_hide_toggled(button_pressed):
	$VBox/Password/Password_input.secret = !button_pressed

func _on_password_copy_pressed():
	DisplayServer.clipboard_set($VBox/Password/Password_input.text)
	await get_tree().create_timer(5).timeout
	$VBox/Password/Copy.button_pressed = false

func _on_remove_pressed():
	$Con_del.popup_centered()

func _on_delete_confirmed():
	get_parent().anchors_preset = PRESET_FULL_RECT
	get_parent().get_parent().get_parent().get_parent()._on_item_deleted()
	get_parent().remove_child(self)
	self.queue_free()
