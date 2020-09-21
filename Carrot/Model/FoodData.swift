//
//  FoodData.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 04/07/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import Foundation

struct FoodData {
    
    static var language = UserDefaults.standard.string(forKey: "language")

    //MARK: - Section names
    static var foodCategories: [String] {
        switch FoodData.language {
            
        // Dutch
        case "nl": return ["Nieuw product", "Groente & fruit 🍅", "Vlees & Vis 🥩", "Zuivel 🥛", "Brood & gebak 🍞", "Drinken 🥤", "Ontbijt 🍳", "Snacks 🍿", "Diepvries 🧊", "Huishouden 🧽", "Overige"]
            
        // Default (English)
        default: return ["New item", "Produce 🍅", "Meat & Fish 🥩", "Dairy 🥛", "Bread & pastries 🍞", "Drinks 🥤", "Breakfast 🍳", "Snacks 🍿", "Frozen 🧊", "Household 🧽", "Other"]
        }
    }
    
    //MARK: - Category items computed properties
    static var vegetables: [String] {
        switch FoodData.language {
                
        // Dutch
        case "nl": return ["aardappel", "aardappelen", "krieltjes", "mini-krieltjes", "zoete aardappel", "zoete aardappels", "komkommer", "komkommers", "rode paprika", "rode paprikas", "gele paprika", "gele paprikas", "groene paprika", "groene paprikas", "courgette", "courgettes", "broccoli", "chiquita bananen", "snoeptomaat", "snoeptomaatje", "snoeptomaatjes", "snoeptomaten", "tomaatje", "tomaatjes", "cherry tomaten", "cherry tomaatjes", "avocado", "avocados", "spinazie", "bloemkool", "champignons", "ijsbergsla", "sla", "kropsla", "aubergine", "trostomaten", "witlof", "sperziebonen", "rode puntpaprikas", "rode puntpaprika's", "puntpaprika's", "puntpaprikas", "rucola", "wortels", "worteltjes", "uien", "ui", "knoflook", "citroenen", "lenteui", "lenteuitje", "elstar", "prei", "preien", "knoflook", "gember", "winterpeen", "rode peper", "snijbonen", "snoepgroente", "bleekselderij","basilicum", "wokgroente", "veldsla", "mais", "maïs", "venkel", "rode bieten", "rode bietjes", "bospeen", "munt", "groene asperges", "asperges", "radijs","radijzen", "koriander", "andijvie", "maiskolven", "maïskolven", "maïskolf", "maiskolf", "tauge", "taugé", "rauwkost", "roerbakgroente", "botersla", "sjalot", "sjalotten", "peterselie", "spruitjes", "verspakket"]
                
        // Default (English)
        default: return ["artichokes", "asparagus", "basil", "beets", "broccoli", "cabbage", "cauliflower", "carrots", "celery", "chilies", "chives", "cilantro", "corn", "cucumbers", "eggplant", "garlic cloves", "green onions", "lettuce", "onions", "peppers", "potatoes", "salad greens", "spinach", "sprouts", "squash", "tomatoes", "zucchini"]
        }
    }
        
    static var fruits: [String] {
        switch FoodData.language {
            
        // Dutch
        case "nl": return ["bananen", "banaan", "appels", "appel", "peren", "peer", "blauwe bessen", "watermeloen", "watermeloenen", "meloen", "meloenen", "chiquita bananen", "aardbeien", "rode druiven", "rode druifjes", "groene druiven", "groene druifjes", "druiven", "witte druiven", "witte druifjes", "frambozen", "blauwe bessen", "mango", "mangos", "citroenen", "mandarijnen", "jonagold", "handsinaasappelen", "perssinaasappelen", "limoenen", "kiwi", "kiwis", "kiwi's", "kiwi’s ", "limoen",  "ananas", "bramen", "granny smith", "fuji", "papaya", "papayas"]
                
        // Default (English)
        default: return ["apples", "apricots", "avocados", "avocado", "bananas", "berries", "cherries", "grapefruit", "grapes", "kiwi", "lemons", "limes", "melons", "nectarines", "oranges", "papaya", "peaches", "pears", "plums", "pomegranate", "watermelon", "banana", "bananas", "apple", "pear"]
            }
    }
    
    static var meat: [String] {
        switch FoodData.language {
            
        // Dutch
        case "nl": return ["rundergehakt", "gehakt", "spekreepje", "spekreepjes", "burger", "bbq", "hamburger", "hamburgers", "ontbijtspek", "schnitzel", "varkensbraadworst", "braadworst", "slavink", "slavinken", "runderchipolata", "chipolata", "biefstuk", "rundervink", "rundervinken", "runderbraadworst", "runderbraadworsten", "kipbraadworst", "speklap", "riblap", "pannenkoekspek",  "pannenkoekenspek", "shoarmareepjes", "shoarmavlees", "shoarma", "rookworst", "bbq burger", "grill burger", "gehaktbal", "gehaktballetjes", "gehaktballen", "rookworsten", "biefstuk","ossenhaas", "schouderkarbonade", "spek", "speklapjes", "braadworst", "ontbijtspek", "rundervinken", "varkenshaas", "cordon bleu", "bamivlees", "schnitzel", "worst", "worstjes", "bbq worst", "vlees", "grillworst", "grillworst kip", "kipgrillworst", "grilworst", "smeerworst"]
                
        // Default (English)
        default: return ["bacon", "chicken", "deli meat", "ground beef", "ground turkey", "ham", "hot dogs", "pork", "sausage", "steak", "turkey", "beef"]
        }
    }
    
    static var fish: [String] {
        switch FoodData.language {
            
        // Dutch
        case "nl": return ["mossel", "mosselen", "zalm", "gerookte zalmfilet", "gerookte zalm", "zalmfilet", "haring", "tonijn", "kabeljauw", "kabeljauwhaas", "vissicks", "makreel", "makreelfilet", "pangasiusfilet", "kabeljauwburger","kibbeling", "zalmsnippers","gamba's","gambas","garnalen","wokgarnalen", "garnaaltjes","garnalenspies","scholfilet", "ansjovisfilet", "ansjovis", "anjovis", "anjovisfilet", "lekkerbekje", "koolvis", "zalmmoot", "tonijnsteak", "sushi", "krab", "oester", "oesters"]
                
        // Default (English)
        default: return ["catfish", "cod", "crab", "halibut", "lobster", "oysters", "salmon", "shrimp", "tilapia", "tuna"]
        
        }
    }
    
    static var dairy: [String] {
        switch FoodData.language {
            
        // Dutch
        case "nl": return ["eieren", "biologische eieren", "melk", "halfvolle melk", "scharreleieren", "yoghurt", "griekse yoghurt", "koffiemelk", "halfvolle koffiemelk", "volle melk", "magere franse kwark", "kwark", "franse kwark", "magere kwark", "drinkyoghurt", "optimel", "roomboter","boter", "karnemelk", "magere yoghurt", "volle youghurt", "roomboter gezouten","roomboter ongezouten","halvarine", "optimel aardbei","optimel aardbei-kers", "vanille vla", "vla", "chocoladevla", "chocolademousse", "mousse", "campina", "chocomelk","chocolademelk", "chocomel","breaker","blue band","blue band halvarine", "amandelmelk", "kookroom", "slagroom", "sour cream","becel","becel light","lactosevrije melk", "sojamelk", "soyamelk", "sojadrink", "arla","skyr","skyr yoghurt","campina vlaflip","paula vla","paula", "feta", "kaas", "jonge kaas", "oude kaas", "belegen kaas", "jong belegen kaas", "jong belegen", "feta kaas", "creme freche", "creme fraiche", "cheddar", "smeerkaas"]
                
        // Default (English)
        default: return ["tofu", "butter", "cheddar cheese", "cream", "cream cheese", "dip", "eggs", "egg substitute", "feta cheese", "half & half", "jack cheese", "milk", "mozzarella", "processed cheese", "salsa", "shredded cheese", "sour cream", "Swiss cheese", "whipped cream", "yogurt"]
        
        }
    }
    
    static var bread: [String] {
        switch FoodData.language {
            
        // Dutch
        case "nl": return ["brood", "broodjes", "witte bollen","witte bolletjes","bolletjes","bruine bolletjes", "kaiserbroodje", "kaiserbroodjes","tijgerbrood","tijgerbrood bruin","half tijgerbrood","tijger bruin","bruin tijgerbrood", "volkoren bollen", "zaans volkoren", "half zaans volkoren", "zaans volkoren half", "meergranen volkoren", "meergranen volkoren half", "half meergranen volkoren", "luchtige crackers", "crackers", "volkoren heel", "krentenbollen", "waldkorn", "tijger volkoren", "mini krentenbollen", "krentenbollen mini", "minicrackers", "stokbrood", "frans stokbrood", "afbakbroodjes", "casino wit", "casino wit half", "hamburgerbroodjes", "madeleine", "croissants", "croissant", "croissantje", "croissantjes","tijger wit","wit tijgerbrood","witte puntjes","cracotte","bruin brood","bruin heel","pita broodjes","pita","pita brood","ciabatta","pistoletjes","pistoletje","ciabattas","italiaanse bol","italiaanse bollen","focaccia","triangel","meergranenbrood","triangel meergranen","croissantdeeg","partybroodjes","bananenbrood","tarwebloem","meel","bloem","bagel","bagels","pistolets","spelt","speltbrood","bakkersbollen","stokbrood kruidenboter","worstenbroodjes","appeltaart","appeltaartjes","appeltaarten","appeltaartje","chocoladetaart","chocotaart","chocoladetaarten","chocoladetaartjes","tijgerbollen","tijgerbol","mini worstenbroodjes"]
                
        // Default (English)
        default: return ["bagels", "bagel", "bread", "donuts", "cake", "cookies", "croutons", "dinner rolls", "hamburger buns", "hot dog buns", "muffins", "pastries", "pie", "pita bread", "tortillas", "corn tortillas", "flour tortillas", "croissant", "bread roll"]
        
        }
    }
    
    static var drinks: [String] {
           switch FoodData.language {
               
           // Dutch
           case "nl": return ["cola","cola fles","siroop","karvan cetivam","karan cetivam","water","bier","heineken","grolsch","wijn","witte wijn","chardonnay","sauvignon","ice tea","ice tea green","lipton ice tea","cola zero","pepsi max","pepsi","coca cola","coca cola light","coca cola zero","cola light","fanta","fanta lemon","fanta orange","koffie","douwe egberts","spa rood","spa blauw","spa groen","sinaasappelsap","fanta zero","appelsientje","tonic","ginger ale","ijsthee","crystal clear","dubbel friss","koffiemelk","mineraalwater","rose","verdejo","pinot grigio","sauvignon blanc","merlot","huiswijn","hertog jan","kratje","kratje bier","kratje heineken","kratje grolsch","kratje hertog jan","corona","leffe","leffe blond","radler","radler 0.0","radles 0%","heineken 0.0","heineken 0%","desperados","brand","affligem","afflichem","weissbier","brouwers pils","brouwers pilsener","pils","amstel","kratje amstel","kratje jupiler","jupiler","sixpack","radler citroen","amstel radler","mojito","gin","bacardi","jenever","amaretto","baileys","irish coffee","irish cream","whisky","vodka","smirnhoff","ice","smirnhoff ice","limoncello","jonge jenever","champagne"]
                   
           // Default (English)
           default: return ["beer", "champagne", "club soda", "coffee", "diet soft drinks", "energy drinks", "juice", "liquor", "soft drinks", "tea", "wine"]
           
           }
       }
    
    static var breakfast: [String] {
        switch FoodData.language {
            
        // Dutch
        case "nl": return ["chocopasta","nutella","chocoladepasta","lijnzaad","chiazaad","ontbijtkoek","snelle jelle","kruidkoek","peijnenburg","koekreep","bolletje ontbijtkoek","pindakaas","calve","calve pindakaas","lavachequirit","la vache qui rit","muesli","havermout","cruesli","quaker","kellogg","choco pops","cornflakes","corn flakes","honey pops","honey loops","hony pop loops","tresor"]
                
        // Default (English)
        default: return ["cereal", "grits", "instant breakfast drink", "oatmeal", "pancake mix"]
        
        }
    }
    
    
    static var snacks: [String] {
        switch FoodData.language {
            
        // Dutch
        case "nl": return ["chips", "stroopwafels", "tony chocolony", "tony chocolonely", "pepernoten", "kruidnoten", "chocopepernoten", "chocoladepepernoten", "kauwgom", "schoolkrijt", "winegums", "dropjes", "drop", "lays", "cheetos", "paprika chips", "naturel chips", "pringles", "pringles original", "pringles naturel", "chocolate chip cookies", "chocolate chip", "ribbelchips", "doritos", "cashewnoten", "verkade", "tortillachips", "buggles", "bastogne", "hamkas", "hamkaas", "tuc", "tucjes", "tuc tuc", "tuc tucjes", "tuctucjes", "lange vingers", "roze koeken", "noodles", "noedles", "walnoten", "liga", "likkoekjes", "bugles", "nibbits", "nibbs", "notenmix", "duyvis", "borrelnootjes", "mergpijpen", "zaans huisje", "chipito", "kaasstengels", "bokkenpootjes", "sultana", "sultanas", "croky", "wafels", "eierwafels", "zeezout karamel", "tonys zeezout", "tonys zeezout karamel", "koekjes", "eierkoeken", "gevulde koeken", "popcorn", "zoute popcorn", "popcorn zout", "popcorn zoet", "zoete popcorn", "chili chips", "AH chips", "nachos", "nacho's", "ah nachos", "nachos ah", "doritos paars", "paarse doritos", "doritos naturel", "schoolkrijtjes"]
                
        // Default (English)
        default: return [
        "candy", "cookies", "crackers", "dried fruit", "fruit snacks", "gelatin", "graham crackers", "granola bars", "gum", "nuts", "popcorn", "potato chips", "pretzels", "pudding", "raisins", "seeds", "tortilla chips"]
        
        }
    }
    
    static var frozen: [String] {
        switch FoodData.language {
            
        // Dutch
        case "nl": return ["ijsjes", "dokter oetker", "dr oetker", "dr. oetker", "pizza salami", "pizza margarita", "raketjes", "ijsblokjes", "ovenfriet", "friet", "cornetto", "split", "ijshoorntjes", "magnum", "mini magnums", "vissticks", "pizza mozzarella", "liuk", "dropijs", "ovenfrikandel", "frikadellen", "frikandellen", "frikandel", "diepvriessnacks", "ovensnacks", "bitterballen", "ovenbitterballen", "pizza", "pizzas", "pizza's", "pizza picante", "pizza pikante"]
                
        // Default (English)
        default: return ["chicken bites", "desserts", "fish sticks", "fruit", "ice", "ice cream", "ice pops", "juice", "meat", "pie shells", "pizza", "pot pies", "potatoes", "TV dinners", "vegetables", "veggie burger", "waffles"]
        }
    }
    
    static var household: [String] {
        switch FoodData.language {
            
        // Dutch
        case "nl": return ["axe", "deo", "deodorant", "axe deo", "zeep", "wasmiddel", "keukenpapier", "keukenrol", "keukenrollen", "toiletrollen", "toiletreiniger", "doekjes", "afvalzakken", "tissues", "zakdoekjes", "tandpasta", "zonnebrand", "handgel", "bekers", "bekertjes", "aluminiumfolie", "zonnebrand", "zeep", "muggenspul", "muggenspray", "shampoo", "conditioner", "douchegel", "axe douchegel", "wax", "gel", "vuilniszakken", "scheermesjes", "scheerschuim"]
                
        // Default (English)
        default: return ["aluminum foil", "coffee filters", "cups", "garbage bags", "napkins", "paper plates", "paper towels", "plastic bags", "plastic cutlery", "plastic wrap", "straws", "waxed paper", "bath soap", "bug repellant", "conditioner", "cotton swabs", "dental floss", "deodorant", "facial tissue", "condoms", "tampons", "pads", "hair spray", "hand soap", "lip care", "lotion", "makeup", "mouthwash", "razors", "blades", "shampoo", "shaving cream", "sunscreen", "toilet tissue", "toothbrush", "toothpaste"]
        }
    }
    
//    // Categories
//    static let foodCategories = ["New item", "Produce 🍅", "Meat 🥩", "Breakfast 🍞", "Seafood 🐟", "Dairy 🥛", "Frozen 🧊", "Drinks 🥤", "Snacks 🍿", "Grains", "Cans & Jars 🥫", "Spices", "Sauces & Oils", "Paper", "Cleaning", "Personal", "Baking 🥧", "Other"]
//
//    // Dutch categories
//    static let groenteFruit: [String] = ["bananen", "banaan", "appels", "appel", "peren", "peer", "blauwe bessen", "watermeloen", "watermeloenen", "meloen", "meloenen", "aardappel", "aardappelen", "krieltjes", "mini-krieltjes", "zoete aardappel", "zoete aardappels", "komkommer", "komkommers", "rode paprika", "rode paprikas", "gele paprika", "gele paprikas", "groene paprika", "groene paprikas", "courgette", "courgettes", "broccoli", "chiquita bananen", "snoeptomaat", "snoeptomaatje", "snoeptomaatjes", "snoeptomaten", "tomaatje", "tomaatjes", "aardbeien", "rode druiven", "rode druifjes", "groene druiven", "groene druifjes", "druiven", "witte druiven", "witte druifjes", "cherry tomaten", "cherry tomaatjes", "avocado", "avocados", "frambozen", "spinazie", "bloemkool", "champignons", "ijsbergsla", "sla", "kropsla", "aubergine", "blauwe bessen", "mango", "mangos", "trostomaten", "witlof", "sperziebonen", "rode puntpaprikas", "rode puntpaprika's", "puntpaprika's", "puntpaprikas", "rucola", "wortels", "worteltjes", "uien", "ui", "knoflook", "citroenen", "lenteui", "lenteuitje", "elstar", "prei", "preien", "mandarijnen", "jonagold", "knoflook", "handsinaasappelen", "perssinaasappelen", "gember", "winterpeen", "rode peper", "snijbonen", "snoepgroente", "bleekselderij","basilicum", "wokgroente", "limoenen", "kiwi", "kiwis", "limoen", "veldsla", "mais", "maïs", "ananas", "bramen", "venkel", "rode bieten", "rode bietjes", "bospeen", "munt", "groene asperges", "asperges", "radijs","radijzen", "koriander", "andijvie", "maiskolven", "maïskolven", "maïskolf", "maiskolf", "tauge", "taugé", "rauwkost", "roerbakgroente", "botersla", "sjalot", "sjalotten", "peterselie", "spruitjes", "granny smith", "fuji", "verspakket", "papaya", "papayas"]
//
//    static let vis: [String] = ["mossel", "mosselen", "zalm", "gerookte zalmfilet", "gerookte zalm", "zalmfilet", "haring", "tonijn", "kabeljauw", "kabeljauwhaas", "vissicks", "makreel", "makreelfilet", "pangasiusfilet", "kabeljauwburger","kibbeling", "zalmsnippers","gamba's","gambas","garnalen","wokgarnalen", "garnaaltjes","garnalenspies","scholfilet", "ansjovisfilet", "ansjovis", "anjovis", "anjovisfilet", "lekkerbekje", "koolvis", "zalmmoot", "tonijnsteak", "sushi", "krab", "oester", "oesters"]
//
//    static let vlees: [String] = ["rundergehakt", "gehakt", "spekreepje", "spekreepjes", "burger", "bbq", "hamburger", "hamburgers", "ontbijtspek", "schnitzel", "varkensbraadworst", "braadworst", "slavink", "slavinken", "runderchipolata", "chipolata", "biefstuk", "rundervink", "rundervinken", "runderbraadworst", "runderbraadworsten", "kipbraadworst", "speklap", "riblap", "pannenkoekspek",  "pannenkoekenspek", "shoarmareepjes", "shoarmavlees", "shoarma", "rookworst", "bbq burger", "grill burger", "gehaktbal", "gehaktballetjes", "gehaktballen", "rookworsten", "biefstuk","ossenhaas", "schouderkarbonade", "spek", "speklapjes", "braadworst", "ontbijtspek", "rundervinken", "varkenshaas", "cordon bleu", "bamivlees", "schnitzel", "worst", "worstjes", "bbq worst", "vlees"]
//
//
//    // English categories
//    static let fruits: [String] = ["apples", "apricots", "avocados", "avocado", "bananas", "berries", "cherries", "grapefruit", "grapes", "kiwi", "lemons", "limes", "melons", "nectarines", "oranges", "papaya", "peaches", "pears", "plums", "pomegranate", "watermelon", "banana", "bananas", "apple", "pear"]
//    static let meat: [String] = ["bacon", "chicken", "deli meat", "ground beef", "ground turkey", "ham", "hot dogs", "pork", "sausage", "steak", "turkey", "beef"]
//    static let baking: [String] = ["baking powder", "baking soda", "bread crumbs", "cake decor", "cake mix", "canned milk", "chocolate chips", "cocoa", "cornmeal", "cornstarch", "flour", "food coloring", "frosting", "muffin mix", "pie crust", "shortening", "brown sugar", "powdered sugar", "sugar", "yeast"]
//    static let grains: [String] = ["brown rice", "burger helper", "couscous", "elbow macaroni", "lasagna", "mac & cheese", "noodle mix", "rice mix", "spaghetti", "white rice"]
//    static let seasoning: [String] = ["basil", "bay leaves", "BBQ seasoning", "cinnamon", "cloves", "cumin", "curry", "dill", "garlic powder", "garlic salt", "gravy mix", "Italian seasoning", "marinade", "meat tenderizer", "oregano", "paprika", "pepper", "poppy seed", "red pepper", "sage", "salt", "seasoned salt", "soup mix", "vanilla extract"]
//    static let vegetables: [String] = ["artichokes", "asparagus", "basil", "beets", "broccoli", "cabbage", "cauliflower", "carrots", "celery", "chilies", "chives", "cilantro", "corn", "cucumbers", "eggplant", "garlic cloves", "green onions", "lettuce", "onions", "peppers", "potatoes", "salad greens", "spinach", "sprouts", "squash", "tomatoes", "zucchini"]
//    static let breakfast: [String] = ["cereal", "grits", "instant breakfast drink", "oatmeal", "pancake mix"]
//    static let seafood: [String] = ["catfish", "cod", "crab", "halibut", "lobster", "oysters", "salmon", "shrimp", "tilapia", "tuna"]
//    static let frozen: [String] = ["chicken bites", "desserts", "fish sticks", "fruit", "ice", "ice cream", "ice pops", "juice", "meat", "pie shells", "pizza", "pot pies", "potatoes", "TV dinners", "vegetables", "veggie burger", "waffles"]
//    static let snacks: [String] = ["candy", "cookies", "crackers", "dried fruit", "fruit snacks", "gelatin", "graham crackers", "granola bars", "gum", "nuts", "popcorn", "potato chips", "pretzels", "pudding", "raisins", "seeds", "tortilla chips"]
//    static let bakery: [String] = ["bagels", "bagel", "bread", "donuts", "cake", "cookies", "croutons", "dinner rolls", "hamburger buns", "hot dog buns", "muffins", "pastries", "pie", "pita bread", "tortillas", "corn tortillas", "flour tortillas", "croissant", "bread roll"]
//    static let cans: [String] = ["applesauce", "baked beans", "black beans", "broth", "bullion cubes", "canned fruit", "canned vegetables", "carrots", "chili", "corn", "creamed corn", "jam", "jelly", "mushrooms", "green olives", "black olives", "pasta", "pasta sauce", "peanut butter", "pickles", "pie filling", "soup"]
//    static let refrigerated: [String] = ["tofu", "biscuits", "butter", "cheddar cheese", "cream", "cream cheese", "dip", "eggs", "egg substitute", "feta cheese", "half & half", "jack cheese", "milk", "mozzarella", "processed cheese", "salsa", "shredded cheese", "sour cream", "Swiss cheese", "whipped cream", "yogurt"]
//    static let sauces: [String] = ["BBQ sauce", "catsup", "cocktail sauce", "cooking spray", "honey", "horseradish", "hot sauce", "lemon juice", "mayonnaise", "mustard", "olive oil", "relish", "salad dressing", "salsa", "soy sauce", "steak sauce", "sweet & sour", "teriyaki", "vegetable oil", "vinegar"]
//    static let drinks: [String] = ["beer", "champagne", "club soda", "coffee", "diet soft drinks", "energy drinks", "juice", "liquor", "soft drinks", "tea", "wine"]
//    static let kitchen = ["aluminum foil", "coffee filters", "cups", "garbage bags", "napkins", "paper plates", "paper towels", "plastic bags", "plastic cutlery", "plastic wrap", "straws", "waxed paper"]
//    static let personal = ["bath soap", "bug repellant", "conditioner", "cotton swabs", "dental floss", "deodorant", "facial tissue", "condoms", "tampons", "pads", "hair spray", "hand soap", "lip care", "lotion", "makeup", "mouthwash", "razors", "blades", "shampoo", "shaving cream", "sunscreen", "toilet tissue", "toothbrush", "toothpaste"]
//



    
    
}
