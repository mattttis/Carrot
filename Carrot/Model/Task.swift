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
    var itemID: String?
    var uid: String?
    
    init(name: String) {
        self.name = name
        self.checked = false
        self.date = Date()
        self.number = 10
        self.category = ""
        self.category = findCategory(itemName: name.lowercased())
    }
    
    init(name: String, isChecked: Bool) {
        self.name = name
        self.checked = isChecked
        self.date = Date()
        self.number = 10
        self.category = ""
        self.category = findCategory(itemName: name.lowercased())
    }
    
    init(name: String, isChecked: Bool, itemID: String) {
        self.name = name
        self.checked = isChecked
        self.date = Date()
        self.number = 10
        self.itemID = itemID
        self.category = ""
        self.category = findCategory(itemName: name.lowercased())
    }
    
    init(name: String, isChecked: Bool, itemID: String, uid: String) {
        self.name = name
        self.checked = isChecked
        self.date = Date()
        self.number = 10
        self.itemID = itemID
        self.category = ""
        self.category = findCategory(itemName: name.lowercased())
        self.uid = uid
    }
    
    init(name: String, uid: String) {
        self.name = name
        self.checked = false
        self.date = Date()
        self.number = 10
        self.category = ""
        self.category = findCategory(itemName: name.lowercased())
        self.uid = uid
    }
    
    
//    private func findCategory (itemName: String) -> String {
//        var category: String
//        if FoodData.fruits.contains(itemName) || FoodData.vegetables.contains(itemName) {
//            category = "Produce 🍅"
//        }
//        else if FoodData.meat.contains(itemName) {
//            category = "Meat 🥩"
//        }
//        else if FoodData.bakery.contains(itemName) || FoodData.baking.contains(itemName) {
//            category = "Baking 🥧"
//        }
//        else if FoodData.breakfast.contains(itemName) {
//            category = "Breakfast 🍞"
//        }
//        else if FoodData.cans.contains(itemName) || FoodData.sauces.contains(itemName) {
//            category = "Cans & Jars 🥫"
//        }
//        else if FoodData.seafood.contains(itemName) {
//            category = "Seafood 🐟"
//        }
//        else if FoodData.drinks.contains(itemName) {
//            category = "Drinks 🥤"
//        }
//        else if FoodData.frozen.contains(itemName) {
//            category = "Frozen 🧊"
//        }
//        else {
//            category = ""
//        }
//        return category
//    }
    
    private func findCategory(itemName: String) -> String {
        var category: String
        if FoodData.fruits.contains(itemName) || FoodData.vegetables.contains(itemName) {
            // Vegetables and fruits
            category = FoodData.foodCategories[1]
        }
        else if FoodData.meat.contains(itemName) || FoodData.fish.contains(itemName) {
            // Meat and fish
            category = FoodData.foodCategories[2]
        }
        else if FoodData.dairy.contains(itemName) {
            // Dairy
            category = FoodData.foodCategories[3]
        }
        else if FoodData.bread.contains(itemName) {
            // Bread and pastries
            category = FoodData.foodCategories[4]
        }
        else if FoodData.drinks.contains(itemName) {
            // Drinks
            category = FoodData.foodCategories[5]
        }
        else if FoodData.breakfast.contains(itemName) {
            // Breakfast
            category = FoodData.foodCategories[6]
        }
        else if FoodData.snacks.contains(itemName) {
            // Snacks
            category = FoodData.foodCategories[7]
        }
        else if FoodData.frozen.contains(itemName) {
            // Frozen
            category = FoodData.foodCategories[8]
        }
        else if FoodData.household.contains(itemName) {
            // Household
            category = FoodData.foodCategories[8]
        }
        else {
            category = ""
        }
        return category
    }
    
}
