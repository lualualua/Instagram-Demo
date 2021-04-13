//
//  DetailTableViewCell.swift
//  Instagram_Demo
//
//  Created by LylaArakawa on 11/04/21.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelSecond: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var images: [UIImage] = []
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setTableviewCell(post: Post) {
        iconImage.image = post.icon
        nameLabel.text = post.name
        images = post.postImage
        nameLabelSecond.text = post.name
        comment.text = post.text
    }
    
}
extension DetailTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = images.count   //PageControlの設定
        pageControl.isHidden = !(images.count > 1)
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        cell.imageContent.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.bounds.size
        cellWidth = collectionViewSize.width
        cellHeight = collectionViewSize.height
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    //PageをスライドしたらPageControlのマークを移動する
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scroll = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(scroll)
    }
    

}
