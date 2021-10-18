extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if len(OS.get_cmdline_args()) > 0:
		var path = str(OS.get_cmdline_args()[0])
		if OS.get_name() == "Windows":
			Global.path = path.replace("\\","/")
			get_tree().change_scene("res://main.tscn")
	else:
		$FileDialog.set_filters(PoolStringArray(["*.cbz ; Comic Book Reader"]))
		$FileDialog.set_current_dir("user://C:/Users/")
		$FileDialog.popup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FileDialog_file_selected(path):
	Global.path = path
	get_tree().change_scene("res://main.tscn")
