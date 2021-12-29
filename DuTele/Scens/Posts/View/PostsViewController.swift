//
//  PostsViewController.swift
//  DuTele
//
//  Created by Mahendra Vishwakarma on 24/12/21.
//

import UIKit
import RxSwift

class PostsViewController: UIViewController {
    

    var disposeBag = DisposeBag()
    var viewModel:ViewModelPosts?
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    //MARK: setup/initilization of viewmodel, tableview
    private func setup() {
        
        viewModel = ViewModelPosts()
       
        postsTableView.register(UINib(nibName: "PostsTableViewCell", bundle: .main), forCellReuseIdentifier: PostsTableViewCell.indenfier)
        postsTableView.dataSource = self
        bindViewModel()
    }
    
    //MARK: bind data with UI. this observer calls on event fired
    func bindViewModel() {
      
        let outputs = viewModel?.outputs
        outputs?.baseStateObservable.asObservable().subscribe(onNext: { [unowned self](state) in
            switch state {
            case .notLoad, .loading:
                self.startLoading()
                
            case .finished:
                self.update()
                
            case .failed:
                self.update()
                
            case .noValid:
                self.update()
            }
        }).disposed(by: disposeBag)
        
    }
    
    //MARK: this methos fetch updated data
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.savedFav()
        viewModel?.localSavedPosts()
        self.navigationController?.isNavigationBarHidden = false

    }
}

//MARK: tableview datasource methods
extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.totalPosts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.indenfier, for: indexPath) as? PostsTableViewCell else {
            fatalError("cell is not initialised")
        }
        cell.btnStart.tag = indexPath.row
        cell.btnStart.addTarget(self, action: #selector(makeFav), for: .touchUpInside)
        if let post = viewModel?.totalPosts?[indexPath.row] {
            cell.setData(post:post )
        
        }
        
        return cell
    }
    
    //MARK: called on to make favourite
    @objc func makeFav(sender:UIButton) {
        if let post = viewModel?.totalPosts?[sender.tag] {
            viewModel?.makeFavourite(postElement: post)
        }
        
    }
    
    //MARK: loader start loading
    func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    //MARK: reload tableview
    func update() {
        DispatchQueue.main.async {
            self.postsTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}
