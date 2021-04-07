//
//  AddPicCollectionViewCell.swift
//  Instagram_Demo
//
//  Created by LylaArakawa on 20/03/21.
//

import UIKit

class AddPicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = 3.0
            self.layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.clear.cgColor
        }
    }
}
