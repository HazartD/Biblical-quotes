extends Control
const album=preload("res://scene/album.tscn")
const cita=preload("res://scene/cita.tscn")
@onready var album_list=$albumes
@onready var new_album=$"albumes/+"
@onready var citas=$Citas
var con=ConfigFile.new()
func _ready():
	for i in DirAccess.get_files_at(Global.DIR):
		var new=album.instantiate()
		new.text=i.erase(i.length()-4,4)
		new.connect("select",open_album)
		album_list.add_child(new)
	#con.set_value("1","book","Gn")

func open_album(_name:String):
	Global.last_album=Global.actual_album.duplicate()
	con.load("user://"+_name+".ini")
	var entries=con.get_sections()
	if !entries.is_empty():
		entries.remove_at(0)
		var dic_entries:Dictionary={}#si es encesario, que haga fill(entries.size()) y solo se igualen
		var ind:int=0
		for i in entries:
			dic_entries[ind]=[]
			dic_entries[ind]+=[con.get_value(i,"book")]
			dic_entries[ind]+=[con.get_value(i,"chapter")]
			dic_entries[ind]+=[con.get_value(i,"initialverse")]
			dic_entries[ind]+=[con.get_value(i,"finalverse")]
			dic_entries[ind]+=[con.get_value(i,"note")]
			ind+=1
		Global.actual_album=dic_entries
	


func _on__button_down():
	pass # Replace with function body.

func dis_seleccion_mode():
	new_album.disabled=false
	for i in new_album.get_parent().get_children(): if i.has_signal("select"):i.connect("select",open_album)
