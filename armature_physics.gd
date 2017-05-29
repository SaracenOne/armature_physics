extends Spatial

const armature_body_const = preload("armature_body.gd")

export(NodePath) var root_path = NodePath()
onready var root = get_node(root_path)

var skeleton = null

var attached_body_ids = {}
var rigid_controller_body_ids = {}
var joints = []

func update_attached_bodies():
	var rigid_array = rigid_controller_body_ids.keys()
	rigid_array.invert()
	
	for attached_body in attached_body_ids.keys():
		attached_body.set_global_transform(skeleton.get_global_transform() * skeleton.get_bone_global_pose(attached_body_ids[attached_body]))
	for rigid in rigid_array:
		if rigid != root:
			rigid.reset_translation()
		skeleton.set_bone_global_pose(rigid_controller_body_ids[rigid], skeleton.get_global_transform().affine_inverse() * rigid.get_global_transform())
		
func cache_child_node(p_node):
	for child in p_node.get_children():
		if child.get_script() == armature_body_const:
			var bone_id = skeleton.find_bone(child.get_bone_name())
			if bone_id > -1:
				if child.bone_should_follow == false:
					attached_body_ids[child] = bone_id
				else:
					rigid_controller_body_ids[child] = bone_id
		elif child extends Joint:
			joints.append(child)
		cache_child_node(child)
	
func cache_physics():
	attached_body_ids = {}
	rigid_controller_body_ids = {}
	if skeleton != null and skeleton extends Skeleton:
		cache_child_node(self)
		
func transform_global_position(p_transform):
	var rigid_array = rigid_controller_body_ids.keys()
	
	# Disable toplevel
	for rigid in rigid_array:
		if rigid != root and rigid.use_toplevel:
			rigid.set_as_toplevel(false)
	
	# Move the root
	root.set_global_transform(p_transform)
	
	for rigid in rigid_array:
		if rigid != root:
			rigid.set_angular_velocity(Vector3())
			rigid.set_linear_velocity(Vector3())
			if rigid.use_toplevel:
				rigid.set_global_transform(rigid.get_parent().get_global_transform() * rigid.initial_transform)
			else:
				rigid.set_transform(rigid.initial_transform)
				
	# Reset joints
	for joint in joints:
		var node_a = joint.get_node_a()
		var node_b = joint.get_node_b()
		joint.set_node_a(NodePath())
		joint.set_node_b(NodePath())
		joint.set_node_a(node_a)
		joint.set_node_b(node_b)
		
	# Reset toplevel
	for rigid in rigid_array:
		if rigid != root and rigid.use_toplevel:
			rigid.set_as_toplevel(true)