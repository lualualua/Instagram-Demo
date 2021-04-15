//
//  AddCommentCollectionViewCell.swift
//  Instagram_Demo
//
//  Created by LylaArakawa on 29/03/21.
//

import UIKit

class AddCommentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var imageView: UIImageView!
    
    func setupCell(image: UIImage) {
        imageView.image = image
        imageView.layer.cornerRadius = 10.0
        imageView.contentMode = .scaleAspectFill
    }
}
