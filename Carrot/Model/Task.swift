//
//  Task.swift
//  Carrot
//
//  Created by Matthijs on 29/06/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import Foundation

class Task {
    var name = ""
    var checked = false
    var date = Date()
    var category: String
    var number: Int
    
    init(name: String) {
        self.name = name
        self.checked = false
        self.date = Date()
        self.number = 0
        self.category = ""
        self.category = findCategory(itemName: name.lowercased())
    }
    
    private func findCategory (itemName: String) -> String {
        var category: String
        if FoodData.fruits.contains(itemName) || FoodData.vegetables.contains(itemName) {
            category = "Produce"
        }
        else if FoodData.meat.contains(itemName) {
            category = "Meat"
        }
        else if FoodData.bakery.contains(itemName) || FoodData.baking.contains(itemName) {
            category = "Baking"
        }
        else if FoodData.breakfast.contains(itemName) {
            category = "Breakfast"
        }
        else if FoodData.cans.contains(itemName) || FoodData.sauces.contains(itemName) {
            category = "Cans & Jars"
        }
        else if FoodData.seafood.contains(itemName) {
            category = "Seafood"
        }
        else if FoodData.drinks.contains(itemName) {
            category = "Drinks"
        }
        else if FoodData.frozen.contains(itemName) {
            category = "Frozen"
        }
        else {
            category = ""
        }
        return category
    }
    
}
