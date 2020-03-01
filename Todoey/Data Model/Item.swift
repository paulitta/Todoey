//
//  Item.swift
//  Todoey
//
//  Created by Paula Montero on 27/02/2020.
//  Copyright © 2020 Paula Montero. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date? //opcional
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //la relación inversa con Category
}
