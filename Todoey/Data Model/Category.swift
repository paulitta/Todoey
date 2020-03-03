//
//  Category.swift
//  Todoey
//
//  Created by Paula Montero on 27/02/2020.
//  Copyright © 2020 Paula Montero. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>() //me marca la relación que hay entre Category e Item
}
