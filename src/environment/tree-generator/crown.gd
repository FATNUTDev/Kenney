tool
extends Node2D

#Create a new Crown and add a collision shape, based on the NineRects size.
#Subtract a Vector2(1,1) to make the collision 1 pixel smaller.
func init(sizeSub, length):
	
	var crown = $crown
	var collision = $crown/StaticBody2D
	var particles = [$crown/Particles2D, $crown/Particles2D2]
	
	set_size_position(sizeSub, length, crown)
	create_collision(crown, collision)
	create_particles(crown, particles)



func create_particles(crown, particles):
	#Create a particlesystem that adds 'leaves'.
	for partsys in particles:
		partsys.position.x = crown.rect_size.x / 2
		partsys.position.y = crown.rect_size.y - 18
		partsys.process_material.emission_box_extents.x = (crown.rect_size.x / 2) - 5

func create_collision(crown, collision):
	var coll_shape = CollisionShape2D.new()
	coll_shape.shape = RectangleShape2D.new()
	coll_shape.one_way_collision = true
	coll_shape.shape.extents = crown.rect_size / 2 - Vector2(1,1)
	coll_shape.position = crown.rect_size / 2
	collision.add_child(coll_shape)

func set_size_position(sizeSub, length, crown):
	
	#Random size
	randomize()
	var randomSize = Vector2(
	int(rand_range(3, 6)), 
	int(rand_range(3, 6)))
	crown.rect_size = randomSize * 18

	#Random position
	randomize()
	var posX = int(rand_range(1, (2 * randomSize.x - 1)))
	crown.rect_position.x = (posX - sizeSub) * -9
	crown.rect_position.y = (length + 4 - sizeSub) * -18
