//
//  Items.swift
//  Todoly
//
//  Created by Glad Poenaru on 2019-12-18.
//  Copyright © 2019 Glad Poenaru. All rights reserved.
//

import Foundation
import RealmSwift

class Items : Object {
    
    @objc dynamic var title : String = " "
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    // category.self = the type of class
    
}
