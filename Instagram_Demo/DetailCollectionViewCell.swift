//
//  DetailCollectionViewCell.swift
//  Instagram_Demo
//
//  Created by LylaArakawa on 11/04/21.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var imageContent: UIImageView!

    func setCollectionViewCell(image: UIImage) {
        imageContent.image = image
    }
}
