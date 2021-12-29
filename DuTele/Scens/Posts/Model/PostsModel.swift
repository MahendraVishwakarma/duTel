//
//  PostsModel.swift
//  DuTele
//
//  Created by Mahendra Vishwakarma on 25/12/21.
//

import Foundation

//MARK: posts atrributes
class PostsElement:Codable {
    let userId:Int?
    let id: Int?
    let title:String?
    let body: String?
    var isFav:Bool?
    
}

//MARK: total posts
typealias PostsModel = [PostsElement]
