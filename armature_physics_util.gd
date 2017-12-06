static func get_skeleton_bone_names(p_skeleton):
	var names = ""
	if(p_skeleton and p_skeleton is Skeleton):
		for i in range(0, p_skeleton.get_bone_count()):
			if(i > 0):
				names += ","
			names += p_skeleton.get_bone_name(i)
	else:
		printerr("invalid skeleton")
	return names

static func add_property_to_list(p_bone_name, p_bone_names, p_list):
	if p_bone_names:
		p_list.push_back({"name":p_bone_name,"type": TYPE_STRING,"hint": PROPERTY_HINT_ENUM,"hint_string":p_bone_names})
	else:
		p_list.push_back({"name":p_bone_name,"type": TYPE_STRING,"hint": PROPERTY_HINT_NONE,"hint_string":p_bone_names})
	return p_list