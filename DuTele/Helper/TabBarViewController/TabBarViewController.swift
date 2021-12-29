//
//  TabBarViewController.swift
//  DuTele
//
//  Created by Mahendra Vishwakarma on 24/12/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setScenes()
    }

    private func setScenes() {
        let button1 = UIBarButtonItem(image: UIImage(named: "logout")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(logout))
        self.navigationItem.rightBarButtonItem  = button1
        self.navigationItem.hidesBackButton = true
        self.tabBar.barTintColor = UIColor(named: "AppTheme")
        self.tabBar.isTranslucent = true
        self.tabBar.tintColor = .white
        self.viewControllers = Utilities.setControllers()
        
    }
    
    @objc func logout() {
        Utilities.makeUserLogout()
        self.navigationController?.popViewController(animated: true)
    }

}
