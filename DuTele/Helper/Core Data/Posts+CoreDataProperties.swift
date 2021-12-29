//
//  Posts+CoreDataProperties.swift
//  DuTele
//
//  Created by Mahendra Vishwakarma on 26/12/21.
//
//

import Foundation
import CoreData


extension Posts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Posts> {
        return NSFetchRequest<Posts>(entityName: "Posts")
    }

    @NSManaged public var post: Data?

}

extension Posts : Identifiable {

}
