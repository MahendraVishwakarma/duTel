//
//  ViewModelFav.swift
//  DuTele
//
//  Created by Mahendra Vishwakarma on 26/12/21.
//

import Foundation

class ViewModelFav {
    
    var viewModel:ViewModelPosts?
    
    init() {
        viewModel = ViewModelPosts()
        viewModel?.savedFav()
        fetchAllPosts()
    }
    
    //MARK: fetch local favourite posts
    func fetchAllPosts()  {
        Utilities.fetchPosts(completion: { (result:Result<PostsModel,DataBaseError>) in
            switch result {
            case .success(let posts):
                self.viewModel?.totalPosts = posts
            case .failure(_):
                
                break
            }
        })
    }
    
    //MARK: get PostsElement model from FavMOdel's id
    func getPost(postID:Int) -> PostsElement?{
        let post = viewModel?.totalPosts?.filter({$0.id == postID}).first
        return post
    }
    
    //MARK: remove favourite
    func removeFav(post:FavPosts?) {
        if let postID = post?.postID {
            let postElement = getPost(postID: Int(postID))
            viewModel?.makeFavourite(postElement: postElement,isFromFav: true)
        }
       
    }
}
