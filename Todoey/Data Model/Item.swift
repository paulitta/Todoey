//
//  Item.swift
//  Todoey
//
//  Created by Paula Montero on 23/02/2020.
//  Copyright © 2020 Paula Montero. All rights reserved.
//

import Foundation

class Item : Codable { //codable es encodable y decodable
    var title : String = ""
    var done : Bool = false
}
