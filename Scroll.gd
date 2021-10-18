extends VBoxContainer

var _positionY


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.min_window_size = Vector2(rect_size.x, 600)
	_positionY = rect_position.y
	_center()
	get_tree().root.connect("size_changed", self, "_center")
	_unzip(Global.path)

func _center():
	rect_position.x = (get_viewport().size.x - (rect_size.x * rect_scale.x))/2
	
func _zoom_in():
	if (rect_size.x * rect_scale.x) < get_viewport().size.x:
		rect_scale.x = rect_scale.x + 0.1
		rect_scale.y = rect_scale.x
		_center()
		rect_position.y =  _positionY *rect_scale.y

func _zoom_out():
	if rect_scale.x > 0.2:
		rect_scale.x = rect_scale.x - 0.1
		rect_scale.y = rect_scale.x
		_center()
		rect_position.y =  _positionY * rect_scale.y

func _scroll_up():
	rect_position.y = rect_position.y +100
	if rect_position.y > 0:
		rect_position.y = 0
	_positionY = rect_position.y / rect_scale.y

func _scroll_down():
	if (_positionY + rect_size.y) > get_viewport().size.y:
		rect_position.y = rect_position.y - 100
		_positionY = rect_position.y / rect_scale.y

func _page_up():
	rect_position.y = rect_position.y  + (get_viewport().size.y - get_viewport().size.y/10)
	if rect_position.y > 0:
		rect_position.y = 0
	_positionY = rect_position.y / rect_scale.y
	print_debug("up")

func _page_down():
	if (_positionY + rect_size.y) > get_viewport().size.y:
		rect_position.y = rect_position.y  - (get_viewport().size.y - get_viewport().size.y/10)
		_positionY = rect_position.y / rect_scale.y
		print_debug("down")
	else:
		print_debug("End")	

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			
			#CTRL + Mouse Scroll UP	=> Zoom in
			if (event.button_index == BUTTON_WHEEL_UP) && event.control:
				_zoom_in()
				
			#CTRL + Mouse Scroll Down => Zoom out
			if (event.button_index == BUTTON_WHEEL_DOWN)  && event.control:
				_zoom_out()

			# Scroll Up
			if (event.button_index == BUTTON_WHEEL_UP) && !event.control:
				_scroll_up()

			# Scroll Down
			if (event.button_index == BUTTON_WHEEL_DOWN)  && !event.control:
				_scroll_down()
	
	if event is InputEventKey and event.pressed:

		if event.scancode == KEY_KP_ADD:
			_zoom_in()

		if event.scancode == KEY_KP_SUBTRACT:
			_zoom_out()

		if event.scancode == KEY_PAGEUP:
			_page_up()
			
		if event.scancode == KEY_PAGEDOWN:
			_page_down()

		if event.scancode == KEY_UP:
			_scroll_up()

		if event.scancode == KEY_DOWN:
			_scroll_down()

func _unzip(path):
	var gdunzip = load('res://addons/gdunzip/gdunzip.gd').new()
	# Load a zip file
	var loaded = gdunzip.load(path)
	if loaded:
		for file in gdunzip.files:
			var uncompressed = gdunzip.uncompress(file)
			var img = Image.new()
			img.load_jpg_from_buffer(uncompressed)
			var tex = ImageTexture.new()
			tex.create_from_image(img)
			var page = TextureRect.new()
			page.texture = tex
			add_child(page)
