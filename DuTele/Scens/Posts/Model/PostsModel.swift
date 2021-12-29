//
//  PostsModel.swift
//  DuTele
//
//  Created by Mahendra Vishwakarma on 25/12/21.
//

import Foundation

class PostsElement:Codable {
    let userId:Int?
    let id: Int?
    let title:String?
    let body: String?
    var isFav:Bool?
    
}

typealias PostsModel = [PostsElement]
