extends Control


func _ready():
	$Panel/VBox/Name_input.grab_focus()


func set_login_file(filename : String):
	$Panel/VBox/Name_input.text = filename


func _on_login_pressed():
	get_parent().try_login($Panel/VBox/Name_input.text, $Panel/VBox/Pass_input/Pass_input.text)

func _on_new_pressed():
	get_parent().try_make_new($Panel/VBox/Name_input.text, $Panel/VBox/Pass_input/Pass_input.text)



func _on_name_input_text_submitted(_new_text):
	$Panel/VBox/Pass_input/Pass_input.grab_focus()

func _on_pass_input_text_submitted(_new_text):
	_on_login_pressed()

func _on_show_hide_toggled(button_pressed):
	$Panel/VBox/Pass_input/Pass_input.secret = !button_pressed
