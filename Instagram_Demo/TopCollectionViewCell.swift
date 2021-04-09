//
//  TopCollectionViewCell.swift
//  Instagram_Demo
//
//  Created by LylaArakawa on 17/03/21.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(post: Post) {
        imageView.image = post.postImage[0]
    }
}
