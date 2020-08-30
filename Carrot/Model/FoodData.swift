//
//  FoodData.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 04/07/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import Foundation

//🥩🥓", "Fish 🐟🍣", "Bread 🍞🥯", "Canned goods 🥫", "Dairy 🥛🧀", "Snacks 🍿🥨", "Frozen foods 🧊", "Produce 🍅🍒"

struct FoodData {
    static let foodCategories = ["New item", "Produce 🍅", "Meat 🥩", "Breakfast 🍞", "Seafood 🐟", "Dairy 🥛", "Frozen 🧊", "Drinks 🥤", "Snacks 🍿", "Grains", "Cans & Jars 🥫", "Spices", "Sauces & Oils", "Paper", "Cleaning", "Personal", "Baking 🥧", "Other"]
    
    static let schappen = ["Nieuw product", "Groente & fruit 🍅", "Vlees & Vis 🥩", "Zuivel 🥛", "Brood & gebak 🍞", "Drinken 🥤", "Ontbijt 🍳", "Snacks 🍿", "Diepvries 🧊", "Huishouden 🧽", "Overige"]
    
    // static let zuivel: [String]
    static let groenteFruit: [String] = ["bananen", "banaan", "appels", "appel", "peren", "peer", "blauwe bessen", "watermeloen", "watermeloenen", "meloen", "meloenen", "aardappel", "aardappelen", "krieltjes", "mini-krieltjes", "zoete aardappel", "zoete aardappels", "komkommer", "komkommers", "rode paprika", "rode paprikas", "gele paprika", "gele paprikas", "groene paprika", "groene paprikas", "courgette", "courgettes", "broccoli", "chiquita bananen", "snoeptomaat", "snoeptomaatje", "snoeptomaatjes", "snoeptomaten", "tomaatje", "tomaatjes", "aardbeien", "rode druiven", "rode druifjes", "groene druiven", "groene druifjes", "druiven", "witte druiven", "witte druifjes", "cherry tomaten", "cherry tomaatjes", "avocado", "avocados", "frambozen", "spinazie", "bloemkool", "champignons", "ijsbergsla", "sla", "kropsla", "aubergine", "blauwe bessen", "mango", "mangos", "trostomaten", "witlof", "sperziebonen", "rode puntpaprikas", "rode puntpaprika's", "puntpaprika's", "puntpaprikas", "rucola", "wortels", "worteltjes", "uien", "ui", "knoflook", "citroenen", "lenteui", "lenteuitje", "elstar", "prei", "preien", "mandarijnen", "jonagold", "knoflook", "handsinaasappelen", "perssinaasappelen", "gember", "winterpeen", "rode peper", "snijbonen", "snoepgroente", "bleekselderij","basilicum", "wokgroente", "limoenen", "kiwi", "kiwis", "limoen", "veldsla", "mais", "maïs", "ananas", "bramen", "venkel", "rode bieten", "rode bietjes", "bospeen", "munt", "groene asperges", "asperges", "radijs","radijzen", "koriander", "andijvie", "maiskolven", "maïskolven", "maïskolf", "maiskolf", "tauge", "taugé", "rauwkost", "roerbakgroente", "botersla", "sjalot", "sjalotten", "peterselie", "spruitjes", "granny smith", "fuji", "verspakket", "papaya", "papayas"]
    
    static let vis: [String] = ["mossel", "mosselen", "zalm", "gerookte zalmfilet", "gerookte zalm", "zalmfilet", "haring", "tonijn", "kabeljauw", "kabeljauwhaas", "vissicks", "makreel", "makreelfilet", "pangasiusfilet", "kabeljauwburger","kibbeling", "zalmsnippers","gamba's","gambas","garnalen","wokgarnalen", "garnaaltjes","garnalenspies","scholfilet", "ansjovisfilet", "ansjovis", "anjovis", "anjovisfilet", "lekkerbekje", "koolvis", "zalmmoot", "tonijnsteak", "sushi", "krab", "oester", "oesters"]
    
    static let vlees: [String] = ["rundergehakt", "gehakt", "spekreepje", "spekreepjes", "burger", "bbq", "hamburger", "hamburgers", "ontbijtspek", "schnitzel", "varkensbraadworst", "braadworst", "slavink", "slavinken", "runderchipolata", "chipolata", "biefstuk", "rundervink", "rundervinken", "runderbraadworst", "runderbraadworsten", "kipbraadworst", "speklap", "riblap", "pannenkoekspek",  "pannenkoekenspek", "shoarmareepjes", "shoarmavlees", "shoarma", "rookworst", "bbq burger", "grill burger", "gehaktbal", "gehaktballetjes","gehaktballen","rookworsten","biefstuk","ossenhaas","schouderkarbonade","spek","speklapjes","braadworst","ontbijtspek","rundervinken","varkenshaas","cordon bleu","bamivlees","schnitzel","worst","worstjes","bbq worst"]
    
    static let fruits: [String] = ["apples", "apricots", "avocados", "avocado", "bananas", "berries", "cherries", "grapefruit", "grapes", "kiwi", "lemons", "limes", "melons", "nectarines", "oranges", "papaya", "peaches", "pears", "plums", "pomegranate", "watermelon", "banana", "bananas", "apple", "pear"]
    static let meat: [String] = ["bacon", "chicken", "deli meat", "ground beef", "ground turkey", "ham", "hot dogs", "pork", "sausage", "steak", "turkey", "beef"]
    static let baking: [String] = ["baking powder", "baking soda", "bread crumbs", "cake decor", "cake mix", "canned milk", "chocolate chips", "cocoa", "cornmeal", "cornstarch", "flour", "food coloring", "frosting", "muffin mix", "pie crust", "shortening", "brown sugar", "powdered sugar", "sugar", "yeast"]
    static let grains: [String] = ["brown rice", "burger helper", "couscous", "elbow macaroni", "lasagna", "mac & cheese", "noodle mix", "rice mix", "spaghetti", "white rice"]
    static let seasoning: [String] = ["basil", "bay leaves", "BBQ seasoning", "cinnamon", "cloves", "cumin", "curry", "dill", "garlic powder", "garlic salt", "gravy mix", "Italian seasoning", "marinade", "meat tenderizer", "oregano", "paprika", "pepper", "poppy seed", "red pepper", "sage", "salt", "seasoned salt", "soup mix", "vanilla extract"]
    static let vegetables: [String] = ["artichokes", "asparagus", "basil", "beets", "broccoli", "cabbage", "cauliflower", "carrots", "celery", "chilies", "chives", "cilantro", "corn", "cucumbers", "eggplant", "garlic cloves", "green onions", "lettuce", "onions", "peppers", "potatoes", "salad greens", "spinach", "sprouts", "squash", "tomatoes", "zucchini"]
    static let breakfast: [String] = ["cereal", "grits", "instant breakfast drink", "oatmeal", "pancake mix"]
    static let seafood: [String] = ["catfish", "cod", "crab", "halibut", "lobster", "oysters", "salmon", "shrimp", "tilapia", "tuna"]
    static let frozen: [String] = ["chicken bites", "desserts", "fish sticks", "fruit", "ice", "ice cream", "ice pops", "juice", "meat", "pie shells", "pizza", "pot pies", "potatoes", "TV dinners", "vegetables", "veggie burger", "waffles"]
    static let snacks: [String] = ["candy", "cookies", "crackers", "dried fruit", "fruit snacks", "gelatin", "graham crackers", "granola bars", "gum", "nuts", "popcorn", "potato chips", "pretzels", "pudding", "raisins", "seeds", "tortilla chips"]
    static let bakery: [String] = ["bagels", "bagel", "bread", "donuts", "cake", "cookies", "croutons", "dinner rolls", "hamburger buns", "hot dog buns", "muffins", "pastries", "pie", "pita bread", "tortillas", "corn tortillas", "flour tortillas", "croissant", "bread roll"]
    static let cans: [String] = ["applesauce", "baked beans", "black beans", "broth", "bullion cubes", "canned fruit", "canned vegetables", "carrots", "chili", "corn", "creamed corn", "jam", "jelly", "mushrooms", "green olives", "black olives", "pasta", "pasta sauce", "peanut butter", "pickles", "pie filling", "soup"]
    static let refrigerated: [String] = ["tofu", "biscuits", "butter", "cheddar cheese", "cream", "cream cheese", "dip", "eggs", "egg substitute", "feta cheese", "half & half", "jack cheese", "milk", "mozzarella", "processed cheese", "salsa", "shredded cheese", "sour cream", "Swiss cheese", "whipped cream", "yogurt"]
    static let sauces: [String] = ["BBQ sauce", "catsup", "cocktail sauce", "cooking spray", "honey", "horseradish", "hot sauce", "lemon juice", "mayonnaise", "mustard", "olive oil", "relish", "salad dressing", "salsa", "soy sauce", "steak sauce", "sweet & sour", "teriyaki", "vegetable oil", "vinegar"]
    static let drinks: [String] = ["beer", "champagne", "club soda", "coffee", "diet soft drinks", "energy drinks", "juice", "liquor", "soft drinks", "tea", "wine"]
    static let kitchen = ["aluminum foil", "coffee filters", "cups", "garbage bags", "napkins", "paper plates", "paper towels", "plastic bags", "plastic cutlery", "plastic wrap", "straws", "waxed paper"]
    static let personal = ["bath soap", "bug repellant", "conditioner", "cotton swabs", "dental floss", "deodorant", "facial tissue", "condoms", "tampons", "pads", "hair spray", "hand soap", "lip care", "lotion", "makeup", "mouthwash", "razors", "blades", "shampoo", "shaving cream", "sunscreen", "toilet tissue", "toothbrush", "toothpaste"]
    
}
