//
//  FavouriteViewController.swift
//  DuTele
//
//  Created by Mahendra Vishwakarma on 24/12/21.
//

import UIKit
import RxSwift

class FavouriteViewController: UIViewController {
    var viewModel:ViewModelFav?
    var disposeBag = DisposeBag()
    @IBOutlet weak var favouriteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    private func setup() {
        
        viewModel = ViewModelFav()
        viewModel?.viewModel?.inputs.fetchPosts.execute()
        viewModel?.viewModel?.savedFav()
        favouriteTableView.register(UINib(nibName: "PostsTableViewCell", bundle: .main), forCellReuseIdentifier: PostsTableViewCell.indenfier)
        favouriteTableView.dataSource = self
        
        bindViewModel()
    }
    
    func bindViewModel() {
        _ = viewModel?.viewModel?.inputs
        let outputs = viewModel?.viewModel?.outputs
        outputs?.baseStateObservable.asObservable().subscribe(onNext: { [unowned self](state) in
            switch state {
            case .notLoad, .loading:
               break
                
            case .finished:
                self.update()
                
            case .failed, .noValid:
                self.update()
                
            }
        }).disposed(by: disposeBag)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewModel?.savedFav()
    }

}

extension FavouriteViewController: UITableViewDataSource, ServerUpdate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.viewModel?.favouriteList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.indenfier, for: indexPath) as? PostsTableViewCell else {
            fatalError("cell is not initialised")
        }
        cell.btnStart.tag = indexPath.row
        cell.btnStart.addTarget(self, action: #selector(removeFav), for: .touchUpInside)
        if let postId = viewModel?.viewModel?.favouriteList?[indexPath.row].postID {
            let post = viewModel?.getPost(postID: Int(postId))
            cell.setData(post:post )
        }
       
        return cell
    }
    @objc func removeFav(sender:UIButton) {
        if let post = viewModel?.viewModel?.favouriteList?[sender.tag] {
            viewModel?.removeFav(post: post)
        }
        
    }
    
    func update() {
        DispatchQueue.main.async {
            self.favouriteTableView.reloadData()
        }
    }
}
