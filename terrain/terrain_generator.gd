extends MeshInstance3D

var mat1 = preload("res://sampler.tres")
const terrainBitmap = preload("res://images/blob.png")

var EDGE_LENGTH = 128
var TILE_SIZE = 4

func _ready() -> void:
	
	#Geometry
	generate_terrain()
	create_trimesh_collision() #collision

	#Texture
	mat1.vertex_color_use_as_albedo = true;
	set_surface_override_material(0, mat1)
	
	#Position
	position = Vector3(-EDGE_LENGTH * TILE_SIZE / 2, 0, -EDGE_LENGTH * TILE_SIZE / 2)
	
func generate_terrain():
	var a_mesh:ArrayMesh
	var surfTool = SurfaceTool.new()
	var collision = ConcavePolygonShape3D.new()	
		
	#Get Heightmap from PNG
	var image = terrainBitmap.get_image()
	if image.is_compressed():
		image.decompress()
	print(image.get_pixel(32, 32).r)	
	
	#Fill the Vertex Array
	surfTool.begin(Mesh.PRIMITIVE_TRIANGLES)	
	for z in range(EDGE_LENGTH+1):
		for x in range(EDGE_LENGTH+1):
			var y = image.get_pixel(x,z).r * 20			
			var uv = Vector2()
			uv.x = inverse_lerp(0, 1, x)
			uv.y = inverse_lerp(0, 1, z)
			surfTool.set_uv(uv)			
			surfTool.set_color(Color(0,1,0,1))							
			surfTool.add_vertex(Vector3(x * TILE_SIZE, y, z * TILE_SIZE))
		
	#Fill the Triangle Index Array
	var index = 0
	for z in range(EDGE_LENGTH):
		for x in range(EDGE_LENGTH):
			surfTool.add_index(index+0)
			surfTool.add_index(index+1)
			surfTool.add_index(index+EDGE_LENGTH+1)
			surfTool.add_index(index+EDGE_LENGTH+1)
			surfTool.add_index(index+1)
			surfTool.add_index(index+EDGE_LENGTH+2)
			index+=1
		index+=1
		
	#Generate Normals
	surfTool.generate_normals()
	
	#Finalize	
	a_mesh = surfTool.commit()
	mesh = a_mesh;
