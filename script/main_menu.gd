extends Control
const album=preload("res://scene/album.tscn")
const cita=preload("res://scene/cita.tscn")
const DIR="user://"
@onready var album_list=$ScrollContainer/albumes
@onready var citas=$album_name/ScrollContainer2/Citas
@onready var album_actual=$album_name
@onready var album_name=$album_name/actual_album
@onready var album_astrac=$album_name/actual_album_astrac
var con=ConfigFile.new()
var actual:String
func _ready()->void:
	for i in DirAccess.get_files_at(DIR):
		var new=album.instantiate()
		new.text=i.erase(i.length()-4,4)
		new.connect("select",open_album)
		album_list.add_child(new)
	DirAccess.make_dir_recursive_absolute("user://config")
	#con.set_value("1","book","Gn")

func open_album(_name:String)->void:
	var nam=DIR+_name+".ini"
	if nam==actual:
		album_actual.show()
		album_list.hide()
		print("ya estaba")
		return
	var err=con.load(nam)
	if err!=OK:return
	var entries=con.get_sections()
	if !entries.is_empty():
		entries.remove_at(0)
		for i in entries:
			var new=cita.instantiate()
			citas.add_child(new)
			new.book.text=con.get_value(i,"book")
			new.cap.text=con.get_value(i,"chapter")
			new.v_i.text=con.get_value(i,"initialverse")
			new.v_f.text=con.get_value(i,"finalverse")
			new.note.text=con.get_value(i,"note")
			new.update_cita_text()
		album_name.text=con.get_value("Data","name")
		album_astrac.text=con.get_value("Data","astrac")
		album_actual.show()
		album_list.hide()
		actual=nam
		print("se cargo")

func dis_seleccion_mode()->void:for i in album_list.get_children(): if i.has_signal("select"):i.connect("select",open_album)
func _on_configuraciones_volver_button_down()->void:
	if album_actual.visible:
		album_actual.hide()
		album_list.show()
		save_con()
	else:
		var conf=load("res://scene/config.tscn")
		var confi=conf.instantiate()
		add_child(confi)
func save_con()->void:
	var changed=false
	for i in citas.get_child_count():
		var data=citas.get_child(i)
		if con.has_section(str(i)):
			if con.get_value(str(i),"book")!=data.book.text:
				con.set_value(str(i),"book",data.book.text)
				changed=true
			if con.get_value(str(i),"chapter")!=data.cap.text:
				con.set_value(str(i),"chapter",str(data.cap.text))
				changed=true
			if con.get_value(str(i),"initialverse")!=data.v_i.text:
				con.set_value(str(i),"initialverse",str(data.v_i.text))
				changed=true
			if con.get_value(str(i),"finalverse")!=data.v_f.text:
				con.set_value(str(i),"finalverse",str(data.v_f.text))
				changed=true
			if con.get_value(str(i),"note")!=data.note.text:
				con.set_value(str(i),"note",str(data.note.text))
				changed=true
			print("tenia esa seccion")
		else:
			con.set_value(str(i),"book",data.book.text)
			con.set_value(str(i),"chapter",str(data.cap.text))
			con.set_value(str(i),"initialverse",str(data.v_i.text))
			con.set_value(str(i),"finalverse",str(data.v_f.text))
			con.set_value(str(i),"note",str(data.note.text))
			changed=true
			print("no tenia esa seccion, se creo")
	if changed:
		con.save(actual)
		print("guardo")
	else:print("no se guardo")

func _on_crear_album_cita_button_down():
	if album_actual.visible:
		var c=cita.instantiate()
		citas.add_child(c)
	else:
		var n=load("res://scene/new_album.tscn")
		var ne=n.instantiate()
		add_child(ne)
