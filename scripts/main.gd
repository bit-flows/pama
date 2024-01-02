extends Control

@onready var back_fader := $Modulate

var items := []
var cur_name := ""
var cur_pass := ""


func _ready():
	DisplayServer.window_set_min_size(Vector2i(380, 520))
	$Login.visible = true
	$File_view.visible = false
	
	var last_user : String = Files.get_last_opend_file()
	if last_user != "":
		$Login.set_login_file(last_user)
		$Login/Panel/VBox/Pass_input/Pass_input.grab_focus()


func show_title(text : String, color : Color = Color.WHITE):
	var title : Label = $File_view/VBox/Topbar/Title
	
	title.label_settings.font_color = color
	title.text = text

func hide_title():
	var title : Label = $File_view/VBox/Topbar/Title
	title.text = ""

func add_item(tag : String, url : String, username : String, password : String):
	var item := [tag, url, username, password]
	items.append(item)

func remove_index(index : int):
	if items.size() > index:
		items.remove_at(index)

func remove_tag(tag : String):
	for idx in items.size():
		if items[idx][0] == tag:
			remove_index(idx)
			break

func clear_items():
	items.clear()


func try_make_new(filename : String, password : String):
	var err : String = Files.save_with_pass([], "user://files/", filename, password)
	
	if err == "OK":
		Files.set_last_opend_file(filename)
		$Login/Panel/VBox/Pass_input/Pass_input.text = ""
		
		$Login.visible = false
		$File_view.visible = true
		
		cur_name = filename
		cur_pass = password
	
	return err

func try_login(filename : String, password : String):
	var resoult = Files.load_with_pass("user://files/", filename, password)
	var err = resoult[0]
	var data = resoult[1]
	
	if err == "OK":
		Files.set_last_opend_file(filename)
		$Login/Panel/VBox/Pass_input/Pass_input.text = ""
		
		items = data
		
		$Login.visible = false
		$File_view.visible = true
		
		cur_name = filename
		cur_pass = password
		
		list_to_items()

func save():
	show_title("Saving...", Color("#BBC927"))
	
	items_to_list()
	var err = Files.save_with_pass(items, "user://files/", cur_name, cur_pass, true)
	
	show_title("Saved", Color("#00D566"))
	await get_tree().create_timer(2).timeout
	hide_title()
	
	return err

func backup():
	save()
	
	var d := DirAccess.open("user://")
	var date := Time.get_date_dict_from_system()
	var time := Time.get_time_dict_from_system()
	var folder_name := "backups/" + str(date.year) + "_" + str(date.month) + "_" + str(date.day) + "/"
	var time_name := str(time.hour) + "_" + str(time.minute) + "_" + str(time.second)
	var new_file_name := cur_name + folder_name.replace("backups/", "").replace("/", "") + "-" + time_name
	
	if not d.dir_exists(folder_name):
		d.make_dir_absolute(folder_name)
	
	d.copy("files/" + cur_name + ".pm", "backups/" + folder_name + new_file_name)

func list_to_items():
	$File_view.remove_all_items()
	for item in items:
		$File_view.add_item(item[0], item[1], item[2], false)

func items_to_list():
	clear_items()
	for item in $File_view.get_items():
		items.append(item.get_variabels())


func _on_tree_exiting():
	pass
	#items.clear()
	#for item in $File_view.get_items():
	#	items.append(item.get_variabels())
	#Files.save_with_pass(items, "user://files/", cur_name, cur_pass, true)
