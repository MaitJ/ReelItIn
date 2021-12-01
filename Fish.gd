extends Node

var fish_name: String
var price: int
var pictureLocation: String
var rarity: String

func _init(fish_name, price, pictureLocation, rarity):
    self.fish_name = fish_name
    self.price = price
    self.pictureLocation = pictureLocation
    self.rarity = rarity