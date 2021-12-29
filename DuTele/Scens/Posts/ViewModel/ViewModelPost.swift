//
//  ViewModelPost.swift
//  DuTele
//
//  Created by Mahendra Vishwakarma on 25/12/21.
//

import Foundation
import CoreData
import UIKit
import RxRelay
import RxSwift
import Action

protocol UsersViewModelInput: BaseViewModelInput {
    var fetchPosts: CocoaAction { get }
}
protocol UsersViewModelOutput: BaseViewModelOuput {
   
}
protocol UsersViewModelType {
  var inputs: UsersViewModelInput { get }
}

class ViewModelPosts:BaseViewModel, UsersViewModelInput, UsersViewModelType, UsersViewModelOutput {
   
    var inputs: UsersViewModelInput { return self }
    var outputs: UsersViewModelOutput { return self }
    
    var totalPosts:PostsModel?
    var favouriteList:Array<FavPosts>?
    
    override init() {
        super.init()
        favouriteList = Array<FavPosts>()
    }
    lazy var fetchPosts: CocoaAction = {
        CocoaAction { [unowned self] _ in
            return self.fetchPostsData()
        }
    }()
    
    func fetchPostsData() -> Observable<Void> {
        
        self.baseStateProperty.onNext(.loading)
        Networking.request(url: AppConstants.postsURL) {[weak self] (result:Result<PostsModel,Error>) in
            switch result {
            case .success(let model):
                self?.totalPosts = model
                self?.savedFav()
                self?.deleteAllData("Posts")
                self?.baseStateProperty.onNext(.finished)
            case .failure(_):

                self?.baseStateProperty.onNext(.failed)
                
            }
        }
        return .empty()
    }
    
    func localSavedPosts() {
        Utilities.fetchPosts(completion: {[weak self] (result:Result<PostsModel,DataBaseError>) in
            switch result {
            case .success(let posts):
                if posts.count <= 0 {
                   _ = self?.fetchPostsData()
                }else {
                    self?.totalPosts = posts
                    self?.savedFav()
                    self?.baseStateProperty.onNext(.finished)
                }
               
                
            case .failure(_):
                _ = self?.fetchPostsData()
                self?.baseStateProperty.onNext(.finished)
                break
            }
        })
    }
    
    func savedFav() {
        let managedContext = Utilities.getContext()
        Utilities.fetch(type: FavPosts.self, managedObjectContext: managedContext) { (postList: [FavPosts]?) in
            
            if let list = postList  {
                self.favouriteList = list
                for object in list {
                    let post = self.totalPosts?.filter({($0.id ?? 0) == object.postID}).first
                    post?.isFav = true
                }
                self.baseStateProperty.onNext(.finished)
                
            }
        }
    }
    
    func saveData() {
        
        let managedContext = Utilities.getContext()
        let post = Posts(context: managedContext)
        
        if let saveObj = totalPosts {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(saveObj) {
                post.post = encoded
                Utilities.saveContext(context: managedContext)
            }
            
        }
        
    }
    
    func makeFavourite(postElement:PostsElement?, isFromFav:Bool = false) {
        postElement?.isFav = !(postElement?.isFav ?? false)
        
        if let validID = postElement?.id {
            let pred = NSPredicate(format: "postID == %i", validID)
            let managedContext = Utilities.getContext()
            Utilities.fetch(type: FavPosts.self, predicate: pred, managedObjectContext: managedContext) { (postList: [FavPosts]?) in
                
                if (postList?.count ?? 0) <= 0 && !isFromFav {
                    
                    let post = FavPosts(context: managedContext)
                    post.postID = Int32(validID)
                    Utilities.saveContext(context: managedContext)
                    
                } else {
                    if let list = postList  {
                        for object in list {
                            
                            managedContext.delete(object)
                            Utilities.saveContext(context: managedContext)
                            
                        }
                    }
                }
                self.savedFav()
                
            }
        }
        
    }
    func deleteAllData(_ entity:String) {
        let managedContext = Utilities.getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
                Utilities.saveContext(context: managedContext)
                
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
        self.saveData()
    }
    
}

protocol ServerUpdate:AnyObject {
    func update()
}
