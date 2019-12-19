//
//  Category.swift
//  Todoly
//
//  Created by Glad Poenaru on 2019-12-18.
//  Copyright © 2019 Glad Poenaru. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = " "
    var items = List<Items>()
    
}
