tool
extends EditorPlugin

func get_name(): 
	return "ArmaturePhysics"

func _enter_tree():
	add_custom_type("ArmatureRigidBody","RigidBody",preload("armature_body.gd"),null)
	add_custom_type("ArmatureStaticBody","StaticBody",preload("armature_body.gd"),null)
func _exit_tree():
	remove_custom_type("ArmatureRigidBody")
	remove_custom_type("ArmatureStaticBody")