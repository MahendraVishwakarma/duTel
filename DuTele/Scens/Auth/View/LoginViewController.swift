//
//  LoginViewController.swift
//  DuTele
//
//  Created by Mahendra Vishwakarma on 23/12/21.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    
    // disposed are used to free memory
    var disposeBag = DisposeBag()
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnLOgin: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    var viewModel:ViewModelLogin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // method contains basic initialization
    private func setup() {
        btnLOgin.setTitleColor(.gray, for: .disabled)
        viewModel = ViewModelLogin()
        bindViewModel()
    }
    
    // it is used to bind UI with Rx subjects
    func bindViewModel() {
       
        if let validViewModel = viewModel {
            // txtEmail bind with userEmail subject
            txtEmail.rx.text.bind(to: validViewModel.userEmail).disposed(by: disposeBag)
            
            // txtPassword bind with userPassword subject
            txtPassword.rx.text.bind(to: validViewModel.userPassword).disposed(by: disposeBag)
            
            // is valid then btnLogin is will be enabled
            viewModel?.isValidForm.bind(to: btnLOgin.rx.isEnabled).disposed(by: disposeBag)
        }
       
    }
    
    
   // method is called on tapped Login button
    @IBAction func login(_ sender: Any) {
        if viewModel?.makeLogin()  == .loginSuccess {
            let obj = TabBarViewController()
            self.navigationController?.pushViewController(obj, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
}
