extends Node

var valid_char := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%&*()-=_+[]{};:,./?"


func _ready():
	setup()


func save_with_pass(data : Array, path : String, filename : String, password : String, overwrite := false):
	var ERR := ""
	
	if DirAccess.open("user://").dir_exists(path.replace("user://", "")):
		var full_path = path + filename + ".pm"
		
		if not FileAccess.file_exists(full_path) or overwrite:
			if FileAccess.file_exists(full_path):
				DirAccess.open(path).remove(filename + ".pm")
			
			var file = FileAccess.open_encrypted_with_pass(full_path, FileAccess.WRITE, password.sha256_text())
			if file:
				file.store_var(data)
				file.close()
				ERR = "OK"
			else:
				ERR = "ERROR_OPENING_FILE"
		else:
			ERR = "FILE_EXISTS"
	else:
		ERR = "PATH_NOT_FOUND"
	
	return ERR

func load_with_pass(path : String, filename : String, password : String):
	var ERR := ""
	var data = null
	
	if DirAccess.open("user://").dir_exists(path.replace("user://", "")):
		var full_path = path + filename + ".pm"
		
		if FileAccess.file_exists(full_path):
			var file = FileAccess.open_encrypted_with_pass(full_path, FileAccess.READ, password.sha256_text())
			if file:
				data = file.get_var()
				file.close()
				ERR = "OK"
			else:
				ERR = "ERROR_OPENING_FILE"
		else:
			ERR = "FILE_EXISTS"
	else:
		ERR = "PATH_NOT_FOUND"
	
	return [ERR, data]


func setup():
	var d := DirAccess.open("user://")
	
	if not d.dir_exists("files/"):
		d.make_dir("files/")

func get_last_opend_file():
	var last := ""
	if FileAccess.file_exists("user://last_user.pms"):
		var f = FileAccess.open("user://last_user.pms", FileAccess.READ)
		last = f.get_as_text()
		f.close()
	return last

func set_last_opend_file(last : String):
	var f = FileAccess.open("user://last_user.pms", FileAccess.WRITE)
	f.store_string(last)
	f.close()
