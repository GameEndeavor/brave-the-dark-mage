tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/tile_buddy/Dock.tscn").instance()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, dock)
	
#	dock.connect("file_updated", self, "_on_file_updated")
#	get_editor_interface().get_resource_filesystem().connect("resources_reimported", self, "_on_resources_reimported")

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()

func _on_resources_reimported(resources : PoolStringArray):
	var base_tileset_resources = dock.option_button
	yield(get_tree(), "idle_frame")
	for resource in resources:
		if base_tileset_resources.has_text(resource):
			dock.call_deferred("generate_auto_tile", resource)

func _on_file_updated(file_path):
	yield(get_tree(), "idle_frame")
	get_editor_interface().get_resource_filesystem().update_file(file_path)
