@tool
extends MultiMeshInstance3D
# Places thousands of copies of the fish created by the AnimatedFish node.
# To use: Change the Instance Count property in the inspector then press the exported Refresh button.
# A high instance count can bloat the scene size; setting the count during runtime may be better.
# See the AnimatedFish node for more documentation.

# Changing the multimesh instance count using the inspector will create new buffer data (transforms)
# filled with random data, causing the models to visually glitch out. Refresh will re-assign good transforms.
@export_tool_button("Refresh", "Reload")
var refresh_action: Callable = setup_multimesh


func _ready() -> void:
	setup_multimesh()


func setup_multimesh() -> void:
	# Give each fish instance a good transform with a random location.
	for i in multimesh.instance_count:
		var xform := Transform3D()
		xform = xform.translated(
				Vector3(randf() * 200 - 20, randf() * 200 - 20, randf() * 200 - 20)
		)
		multimesh.set_instance_transform(i, xform)

		# Optional for extra parameters per fish. The RGB components are used for color.
		# The fourth "alpha" component is used for animation speed.
		# The Particle Fish shader also sets this custom data similarly.
		multimesh.set_instance_custom_data(i, Color(randf(), randf(), randf(), randf()))
