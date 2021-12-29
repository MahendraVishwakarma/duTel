//
//  AppNavigationViewController.swift
//  DuTele
//
//  Created by Mahendra Vishwakarma on 24/12/21.
//

import UIKit

class AppNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor(named: "AppTheme")
        self.navigationBar.isTranslucent = false
      
    }
    
    func logout() {
        
    }
    
}
