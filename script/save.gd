extends Node
var album_list=[]
func save_config()->void:
	pass
func save_album(album_name:String)->void:
	var con=ConfigFile.new()
	
func load_list()->void:
	var file_list=DirAccess.get_files_at("user://")
