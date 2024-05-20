extends Control

export var upgrade_music: AudioStream
export var upgrade_sound_0: AudioStream
export var upgrade_sound_1: AudioStream
export var purchase_failed: AudioStream
export var sold_out: SpriteFrames
#not enough items to justify an external database
#nor the time to set up a proper system q.q
var item_names: Array = [
	"NEXT RUN",
	"SAVE GAME",
	"END GAME",
	"SURFBOARD FINS",
	"SURFBOARD DECK",
	"SURFBOARD RAILS",
	"BLASTER WIDTH",
	"BLASTER LENGTH",
	"BLASTER RECIEVER",
	"METEOR SIZE",
	"FIRE HYDRANT",
	"BEACH ADVERTISEMENT"
]
var base_prices: Array = [
	0, 0, 0,
	50, 100, 200,
	200, 100, 500,
	100, 150, 200
]
var max_upgrade: Array = [
	0, 0, 0,
	6, 45, 2,
	10, 8, 0.3,
	100, 6.4, 1
]
var item_description: Array = [
	"Enough shopping, it's time for surfing!",
	"Save your game",
	"Return to orbit\nDon't forget to save beforehand!",
	"Better fins increase your horizontal movement speed!",
	"A better deck increases your maximum balance!",
	"Better rails help you regain your balance quicker!",
	"Increase your blaster's barrel width.\nIncrease blaster damage!",
	"Increase your blaster's barrel width.\nIncrease projectile speed!",
	"Upgrade your blaster's reciever.\nIncrease rate of fire!",
	"Drop a larger meteor into the ocean. Makes the initial wave larger!",
	"Manipulate the city's water supply.\nDestroying a fire hydrant gives your wave a slight height boost!",
	"Convince some locals to visit the beach!\nIncreases population"
]
var price: int
var index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.change_song(upgrade_music)
	for i in range(3,12):
		update_icon(i)
	update_material_count()


func update_material_count():
	$MaterialContainer/MatCountLabel.set_text(str(PlayerStats.get_materials()))


func update_desc():
	index = $MenuCursor.get_index()
	$UpgradeDescContainer/VBoxContainer/HBoxContainer/ItemNameLabel.set_text(item_names[index])
	$UpgradeDescContainer/VBoxContainer/ItemDescLabel.set_text(item_description[index])
	update_price()


func update_icon(item: int):
	#for each index item > 2:
	#if is_equal_approx(upgrade, max_upgrade[index]):
	#var sprite = $UpgradeImageGrid.get_child(index).get_child(0) as AnimatedSprite
	if item < 3:
		pass
	else:
		var upgrade: float = PlayerStats.get_upgrade(item)
		if is_equal_approx(upgrade, max_upgrade[item]):
			var sprite: AnimatedSprite = $UpgradeImageGrid.get_child(item - 3).get_child(0) as AnimatedSprite
			sprite.set_sprite_frames(sold_out)


func update_price():
	var upgrade: float = PlayerStats.get_upgrade(index)
	var count: int = 0
	price = 0
	
	if index <= 2:
		$UpgradeDescContainer/VBoxContainer/HBoxContainer/ItemCostLabel.set_text("Priceless")
	elif is_equal_approx(upgrade, max_upgrade[index]):
		$UpgradeDescContainer/VBoxContainer/HBoxContainer/ItemCostLabel.set_text("Sold Out")
	else:
		match index:
			3:	#Surfboard Fins (move_speed)
				count = upgrade / 2 - 1
			4:	#Surfboard Deck (max_health)
				count = upgrade / 15 - 1
			5:	#Surfboard Rails (heal_rate)
				count = upgrade * 2 - 1
			6:	#Blaster Width
				count = 0
			7:	#Blaster Length (bullet_speed)
				count = upgrade / 2 - 1
			8:	#Blaster Reciever (fire_rate)
				count = pow(upgrade * 2.0, -1) - 1
			9:	#Meteor size
				count = upgrade * 4 / 100 - 1
			10:	#Fire Hydrant
				count = 0
			11:	#Beach advert
				count = 3 - upgrade / 2		##?
		price = base_prices[index] * pow(1.5 , count)
		$UpgradeDescContainer/VBoxContainer/HBoxContainer/ItemCostLabel.set_text(str(price))


func buy_item():
	#If this item's already at the max (sold out)
	if is_equal_approx(PlayerStats.get_upgrade(index), max_upgrade[index]):
		$MaterialContainer/SoldOutLabel.set_visible(true)
		$MaterialContainer/SoldOutLabel/SoldOutTimer.set_paused(false)
		$MaterialContainer/SoldOutLabel/SoldOutTimer.start(0.75)
		$AudioStreamPlayer.set_stream(purchase_failed)
		$AudioStreamPlayer.play()
	#otherwise, if it's affordable
	elif PlayerStats.get_materials() >= price:
		PlayerStats.buy_item(index, price)
		update_material_count()
		$MaterialContainer/PurchasedLabel.set_visible(true)
		$MaterialContainer/PurchasedLabel/PurchasedTimer.set_paused(false)
		$MaterialContainer/PurchasedLabel/PurchasedTimer.start(0.75)
		match randi() % 2:	#pick a random upgrade sound
			0:
				$AudioStreamPlayer.set_stream(upgrade_sound_0)
			1:
				$AudioStreamPlayer.set_stream(upgrade_sound_1)
		$AudioStreamPlayer.play()
		update_icon(index)
	else:	#if it's not affordable
		$MaterialContainer/CantAffordLabel.set_visible(true)
		$MaterialContainer/CantAffordLabel/CantAffordTimer.set_paused(false)
		$MaterialContainer/CantAffordLabel/CantAffordTimer.start(0.75)
		$AudioStreamPlayer.set_stream(purchase_failed)
		$AudioStreamPlayer.play()


func purchase_timer():
	$MaterialContainer/PurchasedLabel.set_visible(false)
	$MaterialContainer/PurchasedLabel/PurchasedTimer.set_paused(true)


func broke_timer():
	$MaterialContainer/CantAffordLabel.set_visible(false)
	$MaterialContainer/CantAffordLabel/CantAffordTimer.set_paused(true)


func save_timer():
	$MaterialContainer/SaveLabel.set_visible(false)
	$MaterialContainer/SaveLabel/SaveTimer.set_paused(true)


func sold_out_timer():
	$MaterialContainer/SoldOutLabel.set_visible(false)
	$MaterialContainer/SoldOutLabel/SoldOutTimer.set_paused(true)


func end_game():
	Global.goto_scene("res://interface/MenuUI.tscn")


func start_run():
	Global.goto_scene("res://levels/Stage.tscn")


func save_game():
	Global.save_game()
	$MaterialContainer/SaveLabel.set_visible(true)
	$MaterialContainer/SaveLabel/SaveTimer.set_paused(false)
	$MaterialContainer/SaveLabel/SaveTimer.start(0.75)
	match randi() % 2:
		0:
			$AudioStreamPlayer.set_stream(upgrade_sound_0)
		1:
			$AudioStreamPlayer.set_stream(upgrade_sound_1)
	$AudioStreamPlayer.play()
