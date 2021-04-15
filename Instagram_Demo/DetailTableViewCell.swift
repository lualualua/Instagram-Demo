//
//  DetailTableViewCell.swift
//  Instagram_Demo
//
//  Created by LylaArakawa on 11/04/21.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak private var iconImage: UIImageView!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var nameLabelSecond: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak private var pageControl: UIPageControl!
    
    var images: [UIImage] = []
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    //CollectionViewの設定
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailCollectionViewCell")
    }
    
    //TableViewCellの設定
    func setTableviewCell(post: Post) {
        iconImage.image = post.icon
        nameLabel.text = post.name
        images = post.postImage
        nameLabelSecond.text = post.name
        comment.text = post.text
    }
    
}
extension DetailTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        let image = images[indexPath.item]
        cell.setCollectionViewCell(image: image)
        return cell
    }
    
    //PageをスライドしたらPageControlのマークを移動する
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scroll = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(scroll)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = images.count   //PageControlの設定
        pageControl.isHidden = !(images.count > 1) //写真が1枚だったら、PageControlを表示しない
        return images.count
    }
}

//CollectionViewCell（写真）のサイズを調整
extension DetailTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.bounds.size
        cellWidth = collectionViewSize.width
        cellHeight = collectionViewSize.height
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

