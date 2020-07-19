//
//  ExpandableItems.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 10/07/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import Foundation

struct Section {
    var name: String?
    var isExpanded: Bool
    var items: [Task]
}
