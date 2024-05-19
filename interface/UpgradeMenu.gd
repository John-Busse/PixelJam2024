extends Control

export var upgrade_music: AudioStream

var item_names: Array = [
	"SURFBOARD FINS",
	"SURFBOARD DECK",
	"SURFBOARD RAILS",
	"BLASTER WIDTH",
	"BLASTER LENGTH",
	"BLASTER RECIEVER",
	"METEOR SIZE",
	"FIRE HYDRANT",
	"BEACH ADVERTISEMENT",
	"END GAME",
	"SAVE GAME",
	"NEXT RUN"
]

var base_prices: Array = [
	50, 100, 200,
	200, 100, 1000,
	100, 150, 200,
	0, 0, 0
]

var max_upgrade: Array = [
	6, 45, 2,
	10, 8, 0.125,
	100, 6.4, 1,
	0, 0, 0
]

var item_description: Array = [
	"Better fins increase your horizontal movement speed in water!",
	"A better deck increases your maximum balance!",
	"Better rails help you regain your balance quicker!",
	"Increase your blaster's barrel width.\nIncrease blaster damage!",
	"Increase your blaster's barrel width.\nIncrease projectile speed!",
	"Upgrade your blaster's reciever.\nIncrease rate of fire!",
	"Drop a larger meteor into the ocean. Makes the initial wave larger!",
	"Manipulate the city's water supply.\nDestroying a fire hydrant gives your wave a slight height boost!",
	"Convince some locals to visit the beach!\nIncreases population",
	"Return to orbit\nDon't forget to save beforehand!",
	"Save your game",
	"Enough shopping, it's time for surfing!"
]

var price: int
var index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.change_song(upgrade_music)
	update_material_count()


func update_material_count():
	$MaterialContainer/MatCountLabel.set_text(str(PlayerStats.get_materials()))


func update_desc():
	index = $MenuCursor.get_index()
	$UpgradeDescContainer/VBoxContainer/HBoxContainer/ItemNameLabel.set_text(item_names[index])
	$UpgradeDescContainer/VBoxContainer/ItemDescLabel.set_text(item_description[index])
	update_price()


func update_price():
	var sold_out: bool = false
	var upgrade: float = PlayerStats.get_upgrade(index)
	var count: int = 0
	price = 0
	
	if index >= 9:
		$UpgradeDescContainer/VBoxContainer/HBoxContainer/ItemCostLabel.set_text("Priceless")
	elif is_equal_approx(upgrade, max_upgrade[index]):
		$UpgradeDescContainer/VBoxContainer/HBoxContainer/ItemCostLabel.set_text("Sold\nOut")
	else:
		match index:
			0:	#Surfboard Fins (move_speed)
				count = upgrade / 2 - 1
			1:	#Surfboard Deck (max_health)
				count = upgrade / 15 - 1
			2:	#Surfboard Rails (heal_rate)
				count = upgrade * 2 - 1
			3:	#Blaster Width
				count = 0
			4:	#Blaster Length (bullet_speed)
				count = upgrade / 2 - 1
			5:	#Blaster Reciever (fire_rate)
				count = pow(upgrade * 2.0, -1) - 1
			6:	#Meteor size
				count = upgrade * 4 / 100 - 1
			7:	#Fire Hydrant
				count = 0
			8:	#Beach advert
				count = 3 - upgrade / 2		##?
		
		price = base_prices[index] * pow(1.5 , count)
		$UpgradeDescContainer/VBoxContainer/HBoxContainer/ItemCostLabel.set_text(str(price))


func buy_item():
	if PlayerStats.get_materials() >= price:
		PlayerStats.buy_item(index, price)
		update_material_count()
		$MaterialContainer/PurchasedLabel.set_visible(true)
		$MaterialContainer/PurchasedLabel/PurchasedTimer.set_paused(false)
		$MaterialContainer/PurchasedLabel/PurchasedTimer.start(0.75)
	else:
		$MaterialContainer/CantAffordLabel.set_visible(true)
		$MaterialContainer/CantAffordLabel/CantAffordTimer.set_paused(false)
		$MaterialContainer/CantAffordLabel/CantAffordTimer.start(0.75)


func purchase_timer():
	$MaterialContainer/PurchasedLabel.set_visible(false)
	$MaterialContainer/PurchasedLabel/PurchasedTimer.set_paused(true)

func broke_timer():
	$MaterialContainer/CantAffordLabel.set_visible(false)
	$MaterialContainer/CantAffordLabel/CantAffordTimer.set_paused(true)

func save_timer():
	$MaterialContainer/SaveLabel.set_visible(false)
	$MaterialContainer/SaveLabel/SaveTimer.set_paused(true)


func end_game():
	Global.goto_scene("res://interface/MenuUI.tscn")


func start_run():
	Global.goto_scene("res://levels/Stage.tscn")


func save_game():
	Global.save_game()
	$MaterialContainer/SaveLabel.set_visible(true)
	$MaterialContainer/SaveLabel/SaveTimer.set_paused(false)
	$MaterialContainer/SaveLabel/SaveTimer.start(0.75)
