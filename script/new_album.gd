extends Panel
func _on_button_button_down()->void:
	var con=ConfigFile.new()
	con.set_value("DATA","NAME",$name.text)
	con.set_value("DATA","ASTRAC",$descripcion.text)
	con.save(Global.DIR+$name.text)
