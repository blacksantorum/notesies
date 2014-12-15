//
//  Entry.swift
//  Lifeboat
//
//  Created by Chris Tibbs on 12/14/14.
//  Copyright (c) 2014 blacksantorum. All rights reserved.
//

import Foundation
import CoreData

class Entry: NSManagedObject {

    @NSManaged var timeStamp: NSDate
    @NSManaged var title: String
    @NSManaged var content: String

}
