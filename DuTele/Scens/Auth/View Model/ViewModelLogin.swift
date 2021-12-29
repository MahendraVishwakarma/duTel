//
//  LoginViewModel.swift
//  DuTele
//
//  Created by Mahendra Vishwakarma on 23/12/21.
//

import Foundation
import RxSwift
import RxRelay

class ViewModelLogin {
    
    var userEmail = BehaviorRelay<String?>(value: "")
    var userPassword = BehaviorRelay<String?>(value: "")
    
    var isValidForm: Observable<Bool> {
        return Observable.combineLatest(userEmail, userPassword) {email, password in
            guard email != nil && password != nil else {
                return false
            }
            
            return email!.validateEmail() && password!.count >= 6
        }
    }
    
    func makeLogin() -> UserLoginStatus {
        let user = LoginUser(username: userEmail.value, password: userPassword.value)
        return Utilities.makeLoginUser(user: user)
        
    }
    
}

