extends EditorInspectorPlugin

var button_align_single = null
var button_angle_single = null

var label_position : Label
var can_set_position : bool = false
var label_rotation :Label
var can_set_rotation : bool = false
var current_object : Node = null

# Co obsługuje plugin
func _can_handle(object):
	if object is Node:
		current_object = object
	return true

func _parse_begin(object):
	var margin_container = MarginContainer.new()
	margin_container.add_theme_constant_override("margin_left", 15)
	margin_container.add_theme_constant_override("margin_right", 15)
	margin_container.add_theme_constant_override("margin_top", 15)
	margin_container.add_theme_constant_override("bottom", 15)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15)
	
	vbox.add_child(add_control_label("YES GAMES STUDIO TOOLS"))
	vbox.add_child(add_control_label("Wyrównanie pozycji (do 0.5) i rotacji (do 22.5) pojedynczego obiektu:"))
	label_position = add_control_label("Pozycja: ładowanie")
	set_position_label()
	vbox.add_child(label_position)
	
	label_rotation = add_control_label("Rotacja: ładowanie")
	set_rotation_label()
	vbox.add_child(label_rotation)

	vbox.add_child(add_control_button("Wyrównaj pozycję", single_fix_align))
	vbox.add_child(add_control_button("Wyrównaj rotację", single_fix_angle))
	
	vbox.add_child(add_control_label("Masowe poprawki:"))
	vbox.add_child(add_control_button("Popraw pozycję wszystkich dzieci", multi_fix_align))
	vbox.add_child(add_control_button("Popraw rotację wszystkich dzieci", multi_fix_angle))
	
	margin_container.add_child(vbox)
	add_custom_control(margin_container)
	
	

func add_separator():
	return add_control_label("")

func add_control_label(text):
	var l = Label.new()
	l.text = text
	l.autowrap_mode = TextServer.AUTOWRAP_WORD
	return l

func add_control_button(text : String, callable=null):
	var b = Button.new()
	b.text = text
	var style = StyleBoxFlat.new()
	style.bg_color = Color("491682")
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = Color("8d1ebb")
	style.corner_radius_top_left = 15
	style.corner_radius_top_right = 15
	style.corner_radius_bottom_left = 15
	style.corner_radius_bottom_right = 15
	b.add_theme_stylebox_override("normal", style)
	style.bg_color = Color("5C2A95")
	b.add_theme_stylebox_override("hover", style)
	b.add_theme_stylebox_override("pressed", style)
	b.add_theme_stylebox_override("focus", style)
	if callable: b.pressed.connect(callable)

	return b
	
func single_fix_align():
	if current_object == null: return false
	if !(current_object.position is Vector3 or current_object.position is Vector2): return false
	
	var x_rounded = round(current_object.position.x * 2) / 2
	if current_object.position.x != x_rounded: current_object.position.x = x_rounded
	var y_rounded = round(current_object.position.y * 2) / 2
	if current_object.position.y != y_rounded: current_object.position.y = y_rounded
	if current_object.position is Vector3:
		var z_rounded = round(current_object.position.z * 2) / 2
		if current_object.position.z != z_rounded: current_object.position.z = z_rounded
		
	check_position()
	set_position_label()
	
func multi_fix_align():
	if current_object == null: return false
	if !(current_object.position is Vector3 or current_object.position is Vector2): return false
	if current_object.get_child_count() == 0: return false
	
	for child in current_object.get_children():
		if !(child.position is Vector3 or child.position is Vector2): continue
		
		var x_rounded = round(child.position.x * 2) / 2
		if child.position.x != x_rounded: child.position.x = x_rounded
		var y_rounded = round(child.position.y * 2) / 2
		if child.position.y != y_rounded: child.position.y = y_rounded
		if child.position is Vector3:
			var z_rounded = round(child.position.z * 2) / 2
			if child.position.z != z_rounded: child.position.z = z_rounded
		
	check_position()
	set_position_label()
	

func single_fix_angle():
	if current_object == null: return false
	if not current_object.rotation is Vector3: return false
	
	var x_rounded = round(current_object.rotation.x * 22.5) / 22.5
	if current_object.rotation.x != x_rounded: current_object.rotation.x = x_rounded
	var y_rounded = round(current_object.rotation.y * 22.5) / 22.5
	if current_object.rotation.y != y_rounded: current_object.rotation.y = y_rounded
	var z_rounded = round(current_object.rotation.z * 22.5) / 22.5
	if current_object.rotation.z != z_rounded: current_object.rotation.z = z_rounded
	
func multi_fix_angle():
	if current_object == null: return false
	if not current_object.rotation is Vector3: return false
	if current_object.get_child_count() == 0: return false
	

	for child in current_object.get_children():
		if not child.position is Vector3: continue
		
		var x_rounded = round(child.rotation.x * 22.5) / 22.5
		if child.rotation.x != x_rounded: child.rotation.x = x_rounded
		var y_rounded = round(child.rotation.y * 22.5) / 22.5
		if child.rotation.y != y_rounded: child.rotation.y = y_rounded
		var z_rounded = round(child.rotation.z * 22.5) / 22.5
		if child.rotation.z != z_rounded: child.rotation.z = z_rounded
			
	check_rotation()
	set_rotation_label()
	
	
func set_position_label():
	if not current_object: return
	if current_object.position is Vector3 or current_object.position is Vector2:
		label_position.text = "Pozycja: "+str(current_object.position.x)
		label_position.text += ", "+str(current_object.position.y)
		if current_object.position is Vector3:
			label_position.text += ", "+str(current_object.position.z)
		
		can_set_position = true
	else:
		label_position.text = "Pozycja nie jest wektorem."
		can_set_position = false
		
	if check_position(): label_position.add_theme_color_override("font_color", Color.GREEN)
	else: label_position.add_theme_color_override("font_color", Color.RED)

func set_rotation_label():
	if not current_object: return
	if current_object.rotation is Vector3:
		label_rotation.text = "Rotacja: "+str(current_object.rotation.x)
		label_rotation.text += ", "+str(current_object.rotation.y)
		label_rotation.text += ", "+str(current_object.rotation.z)
		can_set_rotation = true
			
	else:
		label_rotation.text = "Rotacja nie jest Vector3."
		can_set_rotation = false
		
	if check_rotation(): label_rotation.add_theme_color_override("font_color", Color.GREEN)
	else: label_rotation.add_theme_color_override("font_color", Color.RED)


func check_position():
	if current_object == null: return false
	if !((current_object.position is Vector3 or current_object.position is Vector2)): return false
	
	var good = true
	if current_object.position.x != round(current_object.position.x *2) /2: good = false
	if current_object.position.y != round(current_object.position.y *2) /2: good = false
	if current_object.position is Vector3:
		if current_object.position.z != round(current_object.position.z *2) /2: good = false
		
	return good
		
func check_rotation():
	if current_object == null or not current_object.rotation is Vector3: return false
	
	var good = true
	if current_object.rotation.x != round(current_object.rotation.x * 22.5) / 22.5: good = false
	if current_object.rotation.y != round(current_object.rotation.y * 22.5) / 22.5: good = false
	if current_object.rotation.z != round(current_object.rotation.z * 22.5) / 22.5: good = false

	return good
