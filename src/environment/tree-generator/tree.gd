tool
extends Node2D

export var height: = 3 setget set_tree_height
export var keep: = false setget set_keep
export var segments: = []
export var crowns: = []

var texture = preload("res://src/environment/tree-generator/tile.png")
var crown = preload("res://src/environment/tree-generator/crown.tscn")


#Inner Classes, to store the tree data. The tree data is used on runtime,
#to generate the same tree as in testing.
class TreeData:
	var segments: = []
	var crowns: = []

#These are Sprite2D nodes!
class TrunkSegment:
	var frame := 0
	var position := Vector2()
	var hframes := 4
	var vframes := 7
	var flip_h := false
	var collision := false

class Crown:
	var radius := 100.0
	

func _ready():
	if not Engine.editor_hint:
		for i in segments.size():
			var sprite = Sprite.new()
			sprite.texture = texture
			sprite.hframes = 4
			sprite.vframes = 4
			sprite.frame = segments[i].frame
			sprite.position = segments[i].position
			self.add_child(sprite)
		

#		var treeData = TreeData.new()
#		treeData.segments = segments
#		treeData.crowns = crowns
#
#		for segment in treeData.segments:
#			var sprite = Sprite.new()
#			sprite.texture = texture
#			sprite.hframes = 4
#			sprite.vframes = 4
#			sprite.frame = segment.frame
#			sprite.position = segment.position
#			self.add_child(sprite)


# - - - - - SETTER - - - - -	
#Keep the seed / shape of the tree.
func set_keep(value):
	keep = value

#Set the height value.
func set_tree_height(value):
	if keep:
		return
	segments.clear()
	setup(value)


#Setup function, that starts the tree creation.
func setup(value):
	#Update the height, minimum and max size defined here.
	height = value
	value += 1
	height = int(clamp(height, 3, 17))
	
	#Delete previous generation:
	var removeChildren = self.get_children()
	for child in removeChildren:
		if child.is_in_group("remove"):
			remove_child(child)
			child.queue_free()
	create_tree(height)


# - - - - - TREE - - - - - 
func create_tree(treeHeight):
	#Create the tree stump once.
	create_part(0, [25], false)
	
	#Height will loop and add sprites for the trunk.
	for trunk in treeHeight:
		trunk += 1
		create_part(trunk, [16, 20, 21, 24, 26] if trunk > 2 else [16, 20], true)
	
	# Create random amount of crowns, based on the height, atleast one.
	var randomRange = Vector2.ZERO
	if height <= 7:
		randomRange = Vector2(1,1)
	if height > 7 and height <= 10:
		randomRange = Vector2(2,2)
	if height > 10:
		randomRange = Vector2(2,3)
	for i in (rand_range(randomRange.x, randomRange.y)):
		create_crown(i, treeHeight)


#This function adds a Sprite Node and sets the properties (specific to this tool).
#It returns the generated Sprite, to generate branches and sprouts (if wanted).
# - - - - - TRUNK / PARTS - - - - - 
func create_part(trunk, spritePool, createBranch):
	
	var sprite = Sprite.new()
	
	sprite.add_to_group("remove")
	sprite.texture = texture
	sprite.hframes = 4
	sprite.vframes = 7
	sprite.z_index = -1
	sprite.position.y = -18 * (trunk + 0.5)
	
	sprite.frame = spritePool[randi() % spritePool.size()]
	self.add_child(sprite)
	
	if createBranch:
		create_branch(trunk, sprite.frame)
	
	#Saving the sprites in Segments
	var savePart = TrunkSegment.new()
	savePart.frame = sprite.frame
	savePart.position = sprite.position
	segments.append(savePart)
	printt(segments, savePart, savePart.frame)
	
	for i in segments.size():
		print(segments[i].frame)
	
	return sprite


# - - - - - BRANCHES - - - - - 
func create_branch(trunk, currentTrunkFrame):
		#Generate branches, depending on trunk frame:
		var randomBranchFrame = [18, 19, 22, 23]
		var randomSproutFrame = [0, 18, 22]
		match currentTrunkFrame:
			#Both branches
			21:
				branch_sprout(trunk, randomBranchFrame, randomSproutFrame, -1)
				branch_sprout(trunk, randomBranchFrame, randomSproutFrame, 1)
			#Left branch
			24:
				branch_sprout(trunk, randomBranchFrame, randomSproutFrame, -1)
			#Right branch
			26:
				branch_sprout(trunk, randomBranchFrame, randomSproutFrame, 1)


#This function creates the branches and sprouts, depending on the trunk frames.
#Depending on the side / orientation, the Sprites need to be flipped.
# - - - - - SPROUTS - - - - - 
func branch_sprout(trunk, branchSprites, sproutSprites, side):
	var branchSprite = create_part(trunk, branchSprites, false)
	branchSprite.position.x = 14 * side
	
	if side == 1 and (branchSprite.frame == 18 or branchSprite.frame == 22):
		branchSprite.flip_h = true
	
	if branchSprite.frame == 19 or branchSprite.frame == 23:
		var sproutSprite = create_part(trunk, sproutSprites, false)
		sproutSprite.position.x = 32 * side
		if sproutSprite.frame == 0:
			sproutSprite.position.y -= 4.5
			sproutSprite.position.x -= 2 * side
			#Create a collision for the little itty bitty floof sprout.
			create_sprout_collision(sproutSprite.position)
	
		if side == 1 and (sproutSprite.frame == 22 or sproutSprite.frame == 18):
			sproutSprite.flip_h = true


#This function creates a small collision for the special floof sprout.
func create_sprout_collision(position):
	var body = StaticBody2D.new()
	var coll_shape = CollisionShape2D.new()
	coll_shape.shape = RectangleShape2D.new()
	coll_shape.one_way_collision = true
	coll_shape.shape.extents = Vector2(8, 8)
	body.position = position
	body.add_to_group("remove")
	self.add_child(body)
	body.add_child(coll_shape)


#This function instances a crown and adds it to the tree.
#The generating part happens in crown.gd!
# - - - - - CROWN - - - - -
func create_crown(sizeSub, treeHeight):
	#Instance a crown
	var newCrown = crown.instance()
	newCrown.z_index = (sizeSub - 1)
	self.add_child(newCrown)
	newCrown.add_to_group("remove")
	newCrown.init(sizeSub, treeHeight)
