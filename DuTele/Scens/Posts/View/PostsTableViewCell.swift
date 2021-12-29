//
//  PostsTableViewCell.swift
//  DuTele
//
//  Created by Mahendra Vishwakarma on 25/12/21.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func draw(_ rect: CGRect) {
        containerView.layer.cornerRadius = 8
        containerView.layer.magnificationFilter = .trilinear
        containerView.layer.masksToBounds = true
    }
    static let indenfier = String(describing: self)
    
    //MARK: bind data with UI
    func setData(post:PostsElement?) {
        titleLabel.text = post?.title
        bodyLabel.text = post?.body
        if (post?.isFav ?? false) {
            btnStart.setImage(UIImage(named: "fav"), for: .normal)
        } else {
            btnStart.setImage(UIImage(named: "star"), for: .normal)
        }
         
    }
}
