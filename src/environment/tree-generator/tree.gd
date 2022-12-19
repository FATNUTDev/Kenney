tool
extends Node2D

export var length: = 3 setget set_tree_length

var texture = preload("res://src/environment/tree-generator/tile.png")
var crown = preload("res://src/environment/tree-generator/crown.tscn")


# - - - - - SETTER - - - - - 
func set_tree_length(value):
	
	#Update the length, minimum and max size defined here.
	length = value
	value += 1
	length = int(clamp(length, 3, 17))
	
	#Delete previous generation:
	var children = self.get_children()
	for child in children:
		if child.is_in_group("remove"):
			remove_child(child)
			child.queue_free()
	create_tree(value)


# - - - - - TREE - - - - - 
func create_tree(value):
	#Length will loop and add sprites for the trunk.
	for trunk in value:
		trunk += 1
		create_part(trunk, [16, 20, 21, 24, 26] if trunk > 2 else [16, 20], true)
	
	
	# Create random amount of crowns, atleast one.
	randomize()
	var randomRange = Vector2(1,1) if value < 10 else Vector2(2,3)
	for i in int(rand_range(randomRange.x, randomRange.y)):
		create_crown(i, length)


# - - - - - TRUNK - - - - - 
func create_part(trunk, spritePool, createBranch):
	
	var sprite = Sprite.new()
	
	sprite.add_to_group("remove")
	sprite.texture = texture
	sprite.hframes = 4
	sprite.vframes = 7
	sprite.z_index = -1
	sprite.position.y = -18 * (trunk + 0.5)
	randomize()
	sprite.frame = spritePool[randi() % spritePool.size()]
	self.add_child(sprite)
	
	if createBranch:
		create_branch(trunk, sprite.frame)
	
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

		if side == 1 and (sproutSprite.frame == 22 or sproutSprite.frame == 18):
			sproutSprite.flip_h = true


# - - - - - CROWN - - - - -
func create_crown(sizeSub, height):
	
	#Instance a crown
	var newCrown = crown.instance()
	self.add_child(newCrown)
	newCrown.add_to_group("remove")
	
	newCrown.init(sizeSub, height)
