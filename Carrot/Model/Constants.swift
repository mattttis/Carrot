//
//  Constants.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 12/07/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import Foundation

struct K {
    static let users = "users"
    static let lists = "lists"
    static let registerSegue = "registerToTable"
    static let loginSegue = "loginToTable"
    static let welcomeSegue = "welcomeToTable"
    
    struct Segues {
        static let registerToTable = "registerToTable"
        static let registerToAddList = "registerToAddList"
        static let addListToTable = "addListToTable"
        static let loginToTable = "loginToTable"
        static let welcomeToTable = "welcomeToTable"
        static let accountToCard = "accountToCard"
        static let tableToShare = "tableToShare"
        static let tableToAccount = "tableToAccount"
        static let tableToCard = "tableToCard"
        static let tableToAddList = "tableToAddList"
    }
    
    struct FStore {
        static let users = "users"
        static let lists = "lists"
        static let sections = "sections"
        static let items = "items"
        static let sectionsDeleted = "sectionsDeleted"
        static let sectionsChecked = "sectionsChecked"
        // static let firstName = "firstname"
        // static let email = "email"
        // static let isChecked = "isChecked"
        // static let checkedBy = "checkedBy"
    }
    
    struct FStorage {
        static let user = "user"
    }
    
    struct User {
        static let firstName = "firstname"
        static let email = "email"
        static let dateCreated = "dateCreated"
        static let lists = "lists"
        static let profilePicture = "profilePicture"
        static let barcodeNumber = "barcodeNumber"
        static let barcodeImage = "barcodeImage"
        static let token = "token"
    }
    
    struct List {
        static let name = "name"
        static let sections = "sections"
        static let dateCreated = "dateCreated"
        static let createdBy = "createdBy"
        static let members = "members"
        static let membersEmail = "membersEmail"
        static let code = "code"
        static let tokens = "tokens"
    }
    
    struct Section {
        static let name = "name"
        static let index = "index"
        static let dateCreated = "dateCreated"
    }
    
    struct Item {
        static let name = "name"
        static let isChecked = "isChecked"
        static let checkedBy = "checkedBy"
        static let uid = "createdBy"
        static let categoryNumber = "categoryNumber"
        static let date = "dateCreated"
        static let dateChecked = "dateChecked"
        static let dateDeleted = "dateDeleted"
        static let firstName = "firstName"
        static let tokens = "tokens"
    }
    
}
