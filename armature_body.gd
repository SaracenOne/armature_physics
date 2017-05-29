tool
extends PhysicsBody

const armature_physics_util_const = preload("armature_physics_util.gd")

var initial_transform = Transform()

var bone_name setget set_bone_name, get_bone_name
export(NodePath) var skeleton_path = NodePath() setget set_skeleton_path
export(bool) var auto_reposition = true

export(bool) var bone_should_follow = false
export(bool) var use_toplevel = false

func reset_translation():
	if use_toplevel == false:
		set_translation(initial_transform.origin)

func set_skeleton_path(p_skeleton_path):
	skeleton_path = p_skeleton_path

func _get_property_list():
	var property_list = []

	if(has_node(skeleton_path)):
		var bone_names = armature_physics_util_const.get_skeleton_bone_names(get_node(skeleton_path))
		property_list = armature_physics_util_const.add_property_to_list("bone", bone_names, property_list)
	else:
		property_list = armature_physics_util_const.add_property_to_list("bone", null, property_list)

	return property_list

func _get(p_property):
	if(p_property == "bone"):
		return get_bone_name()

func _set(p_property, p_value):
	if(p_property == "bone"):
		set_bone_name(p_value)

func set_global_transform_to_bone():
	if(!skeleton_path.is_empty()):
		var skeleton = get_node(skeleton_path)
		if(skeleton):
			var bone_id = skeleton.find_bone(bone_name)
			if(bone_id != -1 and auto_reposition == true):
				set_global_transform(skeleton.get_global_transform() * skeleton.get_bone_global_pose(bone_id))
				
func set_bone_name(p_bone_name):
	bone_name = p_bone_name
	if(is_inside_tree()):
		if(get_tree().is_editor_hint()):
			set_global_transform_to_bone()

func get_bone_name():
	return bone_name

func _ready():
	if has_method("calculate_center_of_mass"):
		calculate_center_of_mass()

	if(get_tree().is_editor_hint()):
		set_global_transform_to_bone()
		
	initial_transform = get_transform()
	
	if use_toplevel == true:
		set_as_toplevel(true)