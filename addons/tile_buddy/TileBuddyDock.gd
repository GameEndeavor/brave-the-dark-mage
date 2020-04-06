tool
extends PanelContainer

signal debug()

const CORNERS = [Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, Vector2.ONE]
const BITMASK_TILESET : TileSet = preload("res://addons/tile_buddy/bitmask_tileset.tres")
const OUTPUT_TILES : Vector2 = Vector2(12, 4)

onready var option_button = $VBoxContainer/HSplitContainer/OptionButton
onready var x_division : SpinBox = $VBoxContainer/HSplitContainer3/VBoxContainer/HSplitContainer/XDivide
onready var y_division : SpinBox = $VBoxContainer/HSplitContainer3/VBoxContainer/HSplitContainer2/YDivide

signal file_updated(path)

var bind_ref = []

func _ready():
	_init_bind_ref()
	generate_auto_tile("res://test_normal.png")
	generate_auto_tile("res://test_offset.png", Vector2(0.5, 0.75))

# Triggered when the user presses the button to generate textures
# Iterates through all added textures, generating an auto-tile for each
func _on_GenerateButton_pressed():
	for i in option_button.get_item_count():
		var file_path = option_button.get_item_text(i)
		var division = Vector2(x_division.value, y_division.value)
		generate_auto_tile(file_path, division)

# Starting method to generate the entire auto-tile
func generate_auto_tile(input_file_path : String, division = Vector2.ONE * 0.5):
	# Append `_autotile` to the end of the input texture file path
	var output_file_path = input_file_path.get_basename() + "_autotile.png"
	var texture = load(input_file_path)
	var input_image = texture.get_data()
	var tile_size = texture.get_size() / Vector2(5, 3)
	var output_image = _generate_texture(tile_size)
	# Iterate for the number of output tiles to generate
	for y in OUTPUT_TILES.y:
		for x in OUTPUT_TILES.x:
			_generate_tile(Vector2(x, y), input_image, output_image, tile_size, division)
	output_image.save_png(output_file_path)
	emit_signal("file_updated", output_file_path)

# Creates the base texture that will be used for the output image
func _generate_texture(tile_size : Vector2) -> Image:
	var image = Image.new()
	# Create texture to accommodate enough tiles (12 x 4)
	image.create(OUTPUT_TILES.x * tile_size.x, OUTPUT_TILES.y * tile_size.y, false, Image.FORMAT_RGBA8)
	# Make completely transmparent
	image.fill(Color(1.0, 1.0, 1.0, 0.0))
	return image

# Where the magic happens. This takes an (x, y) cordinate, get the needed textures from the
# input_image, and uses that to generate the tile needed for the output_image
func _generate_tile(coord : Vector2, input_image : Image, output_image : Image, \
		tile_size : Vector2, division = Vector2(0.5, 0.5)):
	var bitmask = BITMASK_TILESET.autotile_get_bitmask(0, coord)
	if bitmask == 0:
		return
	# Each tile is subdivided into 4 sections
	for i in 4:
		# x and y values for the section of the tile
		# ie 0, 0 for top left, 1, 1 for bottom right
		var section = Vector2()
		section.x = i % 2
		section.y = i / 2
		var corner_offset = (section * (tile_size * division))
		var x_side = section.x * 2 # 0 if left, 2 if right (skips center bitmask)
		var x_mask = bind_ref[x_side][1]
		var y_side = section.y * 2 # 0 if top, 2 if bottom (skips center bitmask)
		var y_mask = bind_ref[1][y_side]
		
		# Find the texture position to use for this subtile
		# TODO: Note which conditions handle which tiles and how logic works
		var src_size = tile_size * \
				Vector2(division.x if section.x == 0 else 1 - division.x, \
				division.y if section.y == 0 else 1 - division.y)
		var src_rect = Rect2(Vector2.ZERO, src_size)
		# If bitmask is true in one of the 3x3 corners relative to the section
		if bitmask & bind_ref[section.x * 2][section.y * 2]:
			# Get the section of the center of the source that will cause the tile to wrap
			src_rect.position = Vector2.ONE * tile_size + corner_offset
		else:
			# Corner Pieces
			# If there is no adjacent tile horizontally or vertically to section
			if !(bitmask & x_mask) && !(bitmask & y_mask):
				src_rect.position = (section * (tile_size * 2)) + corner_offset
				if coord == Vector2(3, 3) && section == Vector2.ONE:
					print(src_rect)
						
			# Horizontal edge pieces
			# If there's an adjacent tile horizontally to the section but not vertically
			elif bitmask & x_mask && !(bitmask & y_mask):
				src_rect.position = Vector2.RIGHT * tile_size + \
						(section * Vector2.DOWN * (tile_size * 2)) + corner_offset
			# Vertical edge pieces
			# If there's an adjacent tile vertically to the section but not horizontally
			elif !(bitmask & x_mask) && bitmask & y_mask:
				src_rect.position = Vector2.DOWN * tile_size + \
						(section * Vector2.RIGHT * (tile_size * 2)) + corner_offset
			# else assume it's an inner corner
			else:
				src_rect.position = Vector2(4, 1) * tile_size - (section * src_size)
		# Apply the sub-tile texture to the output image
		output_image.blit_rect(input_image, src_rect, coord * tile_size + corner_offset)

# TODO: Test!
# Creates an array of bitmasks that represent the 3x3 bitmask of a tile
func _init_bind_ref():
	bind_ref.resize(3)
	for x in 3:
		bind_ref[x] = []
		bind_ref[x].resize(3)
		for y in 3:
			bind_ref[x][y] = 1 << x + y * 3

enum Masks {
	TOP_LEFT, TOP, TOP_RIGHT, LEFT, CENTER, RIGHT, BOTTOM_LEFT, BOTTOM, BOTTOM_RIGHT
}

func bitmask2string(bitmask):
	var string = ""
	
	var strings = []
	for i in Masks.size():
		if bitmask & 1 << i:
			strings.append(Masks.keys()[i])
	
	for i in strings.size():
		string += strings[i]
		if i < strings.size() - 1:
			string += ", "
	
	return string
