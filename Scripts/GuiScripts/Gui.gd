extends Control

func _process(_delta):
	$InventoryItems.text = $"../..".GetInventoryItems()
