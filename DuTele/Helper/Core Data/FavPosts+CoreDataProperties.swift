//
//  FavPosts+CoreDataProperties.swift
//  DuTele
//
//  Created by Mahendra Vishwakarma on 26/12/21.
//
//

import Foundation
import CoreData


extension FavPosts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavPosts> {
        return NSFetchRequest<FavPosts>(entityName: "FavPosts")
    }

    @NSManaged public var postID: Int32

}

extension FavPosts : Identifiable {

}
