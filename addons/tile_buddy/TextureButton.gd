tool
extends OptionButton

var files = []

func can_drop_data(position, data):
	var can_drop = typeof(data) == TYPE_DICTIONARY && data.has("type") && data.type == "files"
	# TODO: Ensure files are pngs
	return can_drop

func drop_data(position, data):
	files = data.files
	
	clear()
	for file in files:
		add_item(file)

func has_text(resource):
	for i in get_item_count():
		if resource == get_item_text(i):
			return true
	
	return false