extends Control


var item_names: Array = [
	"METEOR\nSIZE",
	"FIRE\nHYDRANT",
	#"ASSISTANT",
	"NEXT\nRUN",
	"BLASTER\nWIDTH",
	"BLASTER\nLENGTH",
	"BLASTER\nRECIEVER",
	"SURFBOARD\nDECK",
	"SURFBOARD\nFINS",
	"SURFBOARD\nRAILS"
	#"BEACH\nADVERTISEMENT",
]

var base_prices: Array = [
	200, 200, 1000,
	250, 50, 200,
	100, 250, 500,
	500, 0
]

var max_upgrade: Array = [
	100, 0.5, 1,
	10, 8, 0.125,
	45, 6, 2,
	2, 0
]

var item_description: Array = [
	"Drop a larger meteor into the ocean. Makes the initial wave larger!",
	"Manipulate the city's water supply.\nDestroying a fire hydrant gives your wave a slight height boost!",
	#"Some friends will occasionally fly in to help your run!",
	"Enough shopping, it's time for surfing!",
	"Increase your blaster's barrel width.\nIncrease blaster damage!",
	"Increase your blaster's barrel length.\nIncrease projectile speed!",
	"Upgrade your blaster's reciever.\nIncrease rate of fire!",
	"A better deck increases your maximum balance!",
	"Better fins increase your horizontal movement speed in water!",
	"Better rails help you regain your balance quicker!"
	#"Convince some locals to visit the beach!\nIncreases population",
	
]

var price: int
var index: int

# Called when the node enters the scene tree for the first time.
func _ready():
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
	
	if index == 11:
		$UpgradeDescContainer/VBoxContainer/HBoxContainer/ItemCostLabel.set_text("Priceless")
	elif is_equal_approx(upgrade, max_upgrade[index]):
		$UpgradeDescContainer/VBoxContainer/HBoxContainer/ItemCostLabel.set_text("Sold\nOut")
	else:
		match index:
			0:	#Meteor size
				count = upgrade * 4 / 100 - 1
			1, 2:	#Fire Hydrant,Blaster Width
			#1, 2, 3 #Fire Hydrant, Assistant, Blaster Width
				count = 0
			4:	#Blaster Length (bullet_speed)
				count = upgrade / 2 - 1
			5:	#Blaster Reciever (fire_rate)
				count = pow(upgrade * 2.0, -1) - 1
			6:	#Surfboard Deck (max_health)
				count = upgrade / 15 - 1
			7:	#Surfboard Fins (move_speed)
				count = upgrade / 2 - 1
			8:	#Surfboard Rails (heal_rate)
				count = upgrade * 2 - 1
			9:	#beach ads (enemy_timer)
				count = 3 - upgrade / 2
		
		price = base_prices[index] * pow(1.5 , count)
		$UpgradeDescContainer/VBoxContainer/HBoxContainer/ItemCostLabel.set_text(str(price))


func buy_item():
	if PlayerStats.get_materials() >= price:
		PlayerStats.buy_item(index, price)
		update_material_count()
		$MaterialContainer/PurchasedLabel.set_visible(true)
		$MaterialContainer/PurchasedLabel/PurchasedTimer.set_wait_time(0.75)
		$MaterialContainer/PurchasedLabel/PurchasedTimer.set_paused(false)
		$MaterialContainer/PurchasedLabel/PurchasedTimer.start()
	else:
		$MaterialContainer/CantAffordLabel.set_visible(true)
		$MaterialContainer/CantAffordLabel/CantAffordTimer.set_wait_time(0.75)
		$MaterialContainer/CantAffordLabel/CantAffordTimer.set_paused(false)
		$MaterialContainer/CantAffordLabel/CantAffordTimer.start()


func purchase_timer():
	$MaterialContainer/PurchasedLabel.set_visible(false)
	$MaterialContainer/PurchasedLabel/PurchasedTimer.set_paused(true)
	$MaterialContainer/PurchasedLabel/PurchasedTimer.set_wait_time(0.75)

func broke_timer():
	$MaterialContainer/CantAffordLabel.set_visible(false)
	$MaterialContainer/CantAffordLabel/CantAffordTimer.set_paused(true)
	$MaterialContainer/CantAffordLabel/CantAffordTimer.set_wait_time(0.75)


func start_run():
	Global.goto_scene("res://levels/Stage.tscn")
