//
//  Utilities.swift
//  DuTele
//  Utilities have multiple util methods
//  Created by Mahendra Vishwakarma on 24/12/21.
//  Common Methods
//  Reusable
//

import Foundation
import UIKit
import CoreData

struct Utilities {
    
    static func isUserLogin() -> Bool {
        if let userData = UserDefaults.standard.data(forKey: AppConstants.user) {
            let decode = JSONDecoder()
            do {
                let user = try decode.decode(LoginUser.self, from: userData)
                return (user.username?.count ?? 0 > 0 && user.password?.count ?? 0 > 0 ) ? true : false
                
            } catch {
                return false
            }
            
        }
        
        return false
    }
    
    static func makeUserLogout() {
       UserDefaults.standard.removeObject(forKey: AppConstants.user)
         
    }
    
    static func makeLoginUser(user: LoginUser) -> UserLoginStatus {
        let enode = JSONEncoder()
        do {
            let userEncoded = try enode.encode(user)
            UserDefaults.standard.setValue(userEncoded, forKey: AppConstants.user)
            return .loginSuccess
            
        } catch {
            return .loginFailed
        }
        
    }
    
    static func rootControllers() -> UINavigationController {
       
        let navVC = AppNavigationViewController(rootViewController: LoginViewController())
        navVC.navigationItem.hidesBackButton = true
        return navVC
    }
    static func setControllers() ->[UIViewController] {
        let postsVC = PostsViewController()
        let icon1 = UITabBarItem(title: "Posts", image: UIImage(named: "posts.png"), selectedImage: UIImage(named: "posts.png"))
        postsVC.tabBarItem = icon1
        
        let favVC = FavouriteViewController()
        let icon2 = UITabBarItem(title: "Favourite", image: UIImage(named: "star.png"), selectedImage: UIImage(named: "star.png"))
        favVC.tabBarItem = icon2
        
        return [postsVC, favVC]
    }
    
    static func logoutUser() {
        UserDefaults.standard.removeObject(forKey: AppConstants.user)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Generic Fetch Helper Method
    static func fetch<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, managedObjectContext: NSManagedObjectContext, completion: @escaping (([T]?) -> Void)) {
        
        managedObjectContext.perform {
            let request: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: type))
            if let predicate = predicate {
                request.predicate = predicate
            }
            if let sortDescriptors = sortDescriptors {
                request.sortDescriptors = sortDescriptors
            }
            do {
                let result = try managedObjectContext.fetch(request)
                completion(result)
            } catch {
                completion(nil)
            }
        }
    }
    static func getContext() -> NSManagedObjectContext {
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        
        let persistence = appDel.persistentContainer.viewContext
        return persistence
    }
    static func saveContext(context:NSManagedObjectContext) {
        do {
            try context.save()
        }catch {
            
        }
        
    }
    static func fetchPosts<T:Decodable>(completion: @escaping (Result<T, DataBaseError>) -> Void) {
        let managedContext = getContext()
        Utilities.fetch(type: Posts.self, managedObjectContext: managedContext) {  (postList: [Posts]?) in
            guard let list = postList,
                  list.count > 0 else {
                completion(.failure(.noDataFound(String(describing: PostsModel.self))))
                return
            }
            do {
                if let data = list.first, let decodaData = data.post {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(T.self, from: decodaData)
                    completion(.success(decoded))
                    
                    
                } else {
                    completion(.failure(.noDataFound("no data")))
                }
                
            } catch let error {
                completion(.failure(.noDataFound(error.localizedDescription)))
            }
            
        }
    }
    
}

enum UserLoginStatus {
    case loginSuccess
    case loginFailed
}

// MARK: DataBase Error Customize
enum DataBaseError: Error {
    case badExcess
    case noDataFound(String)
}

//MARK: check string to validat email
extension String {
    func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
}
