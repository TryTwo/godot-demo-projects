@tool
extends MeshInstance3D
# Animes a fish model using a shader. Not required for other nodes to work.

# This tool script is written to provide an example made with minimal setup using the inspector, while still providing a preview of the fish. The original fish is an export to provide an unedited mesh every time the script runs.

@export var Fish : Mesh:
	set(value):
		Fish = value
		if Engine.is_editor_hint():
			convert_surface_materials()
			share_mesh()
		
@onready var ManyFish : MultiMeshInstance3D = $"../MultiMeshInstance3D"
@onready var ParticleFish : GPUParticles3D = $"../ParticleFish"

func _ready():
	convert_surface_materials()
	share_mesh()
	
func share_mesh():
	# Shares the mesh with other nodes so they won't need to repeat this work.
	ManyFish.multimesh.mesh = mesh
	ParticleFish.draw_pass_1 = mesh

func convert_surface_materials():
	if Fish is not Mesh:
		return
		
	# Duplicate the mesh so changes don't affect all instances. Can use "make unique" in the inspector instead.
	mesh = Fish.duplicate()
	
	# Setup mesh data the shader will need. These can be set using any type of shader uniform (normal instance, or global).
	var mesh_length = Fish.get_aabb().size.z
	var mesh_center = Fish.get_aabb().position + Fish.get_aabb().size / 2.0
	
	# Our custom shader to animate the fish.
	var shader = load("res://fish.gdshader")
	
	# Iterate through surfaces on the mesh and copy any parameters that need to be kept.
	for i in mesh.get_surface_count():
		# Create a new shader material for each surface so properties can be different. Rhe shader itself is shared.
		var new_mat = ShaderMaterial.new()
		new_mat.shader= shader
		
		# Get properties from the original mesh surface.
		var old_mat = Fish.surface_get_material(i)
		var color = old_mat.albedo_color
		
		# Load each property into the custom fish shader. These need to be processed in the shader file.
		new_mat.set_shader_parameter("albedo", color)
		new_mat.set_shader_parameter("mesh_length", mesh_length)
		new_mat.set_shader_parameter("mesh_center", mesh_center)
		
		# Attach the new material to the mesh surface, overwriting the old one and allowing a shader to be applied.
		mesh.surface_set_material(i, new_mat)
