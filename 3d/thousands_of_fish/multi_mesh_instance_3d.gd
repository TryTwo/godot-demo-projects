@tool
extends MultiMeshInstance3D
# Creates an animated fish and places thousands of copies. To use: change instance count
# in the inspector then press the exported refresh button.
# See the AnimatedFish node for more documentation. 

# Changing the multimesh instance count using the inspector will create new buffer data (transforms) filled with random data, causing the models to visually glitch out. Refresh will re-assign good transforms.
@export_tool_button("Refresh")
var refresh_action = setup_multimesh

func _ready():
	setup_multimesh()
	
func setup_multimesh():
	# Give each fish instance a good transform with a random location.
	for i in range(multimesh.instance_count):
		var xform := Transform3D()
		xform = xform.translated(Vector3(randf() * 200 - 20, randf() * 200 - 20, randf() * 200 - 20))
		multimesh.set_instance_transform(i, xform)
		# Optional for extra parameters per fish.
		multimesh.set_instance_custom_data(i, Color(randf(), randf(), randf(), randf()))
