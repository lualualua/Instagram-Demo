//
//  DetailTableViewCell.swift
//  Instagram_Demo
//
//  Created by LylaArakawa on 17/03/21.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var nameLabelSecond: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    func setTableviewCell(post: Post) {
        iconImage.image = post.icon
        nameLabel.text = post.name
        imageContent.image = post.postImage
        nameLabelSecond.text = post.name
        comment.text = post.text
    }
    
}
